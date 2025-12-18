import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/core/constants/app_constants.dart';
import 'package:flutter_template/core/di/injection_container.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/theme/theme_extensions.dart';
import 'package:flutter_template/domain/entities/movie.dart';
import 'package:flutter_template/presentation/home/bloc/movie_bloc.dart';
import 'package:flutter_template/presentation/widgets/loading_widgets.dart';
import 'package:flutter_template/presentation/widgets/error_state_widgets.dart';
import 'package:flutter_template/presentation/widgets/floating_like_button.dart';

// Widget part files
part '../widgets/movie_page_card.dart';

class _HomePageConstants {
  static const double likeButtonBottom = 191;
  static const double movieInfoBottom = 100;
  static const double loadingIndicatorBottom = 120;
  static const double movieInfoWidth = 278.21;
  static const double movieInfoHeight = 75;
  static const double containerHeight = 107;
  static const int descriptionMaxLength = 60;
  static const int preloadTriggerPosition = 2;
  static const double refreshFirstPageThreshold = 0.5;

  static const Duration refreshDelay = Duration(milliseconds: 500);

  static List<Color> backgroundGradient(BuildContext context) {
    final gradientColors = Theme.of(
      context,
    ).extension<ThemeGradientColors>()?.gradientColors;
    return gradientColors ?? [AppColors.bgDark, const Color(0xFF3E0205)];
  }

  static const List<double> overlayStops = [0.00, 0.15, 0.74, 0.89];

  static const List<Color> overlayColors = [
    Color(0x66090909),
    Color(0x00090909),
    Color(0x00090909),
    Color(0xE6090909),
  ];
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MovieBloc(getMovieListUseCase: sl(), toggleFavoriteUseCase: sl())
            ..add(const MovieLoadRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          return switch (state.status) {
            MovieStatus.initial => _buildLoadingState(),
            MovieStatus.loading => _buildLoadingState(),
            MovieStatus.loadingMore => _buildMovieList(state),
            MovieStatus.success => _buildMovieList(state),
            MovieStatus.empty => _buildEmptyState(),
            MovieStatus.failure => _buildErrorState(
              state.errorMessage,
              context,
            ),
          };
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return GradientLoadingPage(
      gradientColors: _HomePageConstants.backgroundGradient(context),
    );
  }

  Widget _buildErrorState(String? errorMessage, BuildContext context) {
    return GradientErrorState(
      message: errorMessage,
      gradientColors: _HomePageConstants.backgroundGradient(context),
      onRetry: () {
        context.read<MovieBloc>().add(const MovieRefresh());
      },
    );
  }

  Widget _buildEmptyState() {
    return GradientEmptyState(
      message: context.l10n.noMoviesYet,
      gradientColors: _HomePageConstants.backgroundGradient(context),
    );
  }

  Widget _buildMovieList(MovieState state) {
    return Stack(
      children: [
        _buildPageView(state),
        if (state.status == MovieStatus.loadingMore) _buildLoadingIndicator(),
        if (state.movies.isNotEmpty) _buildFixedLikeButton(state),
      ],
    );
  }

  Widget _buildPageView(MovieState state) {
    return RefreshIndicator(
      color: AppColors.primaryOf(context),
      backgroundColor: AppColors.bgDark,
      onRefresh: () => _handleRefresh(context),
      notificationPredicate: _canRefresh,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) => _handlePageChanged(index, state, context),
        itemCount: state.movies.length,
        itemBuilder: (context, index) {
          final movie = state.movies[index];
          return _MoviePage(movie: movie);
        },
      ),
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    context.read<MovieBloc>().add(const MovieRefresh());
    await Future.delayed(_HomePageConstants.refreshDelay);
  }

  bool _canRefresh(ScrollNotification notification) {
    return _pageController.hasClients &&
        _pageController.page != null &&
        _pageController.page! < _HomePageConstants.refreshFirstPageThreshold;
  }

  /*
   * NOT: Sayfa değişikliğinde pagination mantığını yönetir.
   * Kullanıcı sayfanın sonuna yaklaşırken yeni filmler yüklenir (preload).
   * Bu sayede sonsuz scroll deneyimi kesintisiz olur.
   */
  void _handlePageChanged(int index, MovieState state, BuildContext context) {
    setState(() {});

    final currentApiPage = (index / AppConstants.moviesPerPage).floor() + 1;
    final positionInPage = index % AppConstants.moviesPerPage;

    if (kDebugMode) {
      debugPrint(
        '📄 Film index: $index, API Page: $currentApiPage, Position in page: ${positionInPage + 1}/${AppConstants.moviesPerPage}',
      );
      debugPrint(
        '   State - currentPage: ${state.currentPage}, Total movies: ${state.movies.length}, hasReachedMax: ${state.hasReachedMax}',
      );
    }

    if (_shouldLoadNextPage(positionInPage, currentApiPage, state)) {
      if (kDebugMode) {
        debugPrint('🔄 Loading page ${state.currentPage + 1}...');
      }
      context.read<MovieBloc>().add(const MovieLoadMore());
    }
  }

  /*
   * Yeni sayfa yükleme koşullarını kontrol eder.
   * - Kullanıcı sayfanın 3. filmindeyse (preloadTriggerPosition)
   * - Hala yüklenecek sayfa varsa
   * - Şu anda yükleme yapılmıyorsa
   */
  bool _shouldLoadNextPage(
    int positionInPage,
    int currentApiPage,
    MovieState state,
  ) {
    return positionInPage == _HomePageConstants.preloadTriggerPosition &&
        currentApiPage == state.currentPage &&
        !state.hasReachedMax &&
        state.status != MovieStatus.loadingMore;
  }

  Widget _buildLoadingIndicator() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: _HomePageConstants.loadingIndicatorBottom.h,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  color: AppColors.primaryOf(context),
                  strokeWidth: 2,
                ),
              ),
              12.horizontalSpace,
              Text(
                context.l10n.loading,
                style: AppTypography.bodyNormalRegular.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFixedLikeButton(MovieState state) {
    final currentMovie = _getCurrentMovie(state);

    return FloatingLikeButton(
      movie: currentMovie,
      onTap: () {
        context.read<MovieBloc>().add(
              MovieToggleFavorite(currentMovie.id),
            );
      },
      bottom: _HomePageConstants.likeButtonBottom.h,
    );
  }

  Movie _getCurrentMovie(MovieState state) {
    final currentIndex =
        _pageController.hasClients && _pageController.page != null
            ? _pageController.page!.round()
            : 0;
    return state.movies[currentIndex.clamp(0, state.movies.length - 1)];
  }
}
