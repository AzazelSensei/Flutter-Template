import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/di/injection_container.dart';
import 'package:flutter_template/core/error/error_handler.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/extensions/sliver_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/locale/locale_cubit.dart';
import 'package:flutter_template/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter_template/presentation/profile/view/profile_photo_setup_page.dart';
import 'package:flutter_template/core/theme/theme_cubit.dart';
import 'package:flutter_template/presentation/widgets/limited_offer_bottom_sheet.dart';
import 'package:flutter_template/presentation/widgets/settings_bottom_sheet.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';
import 'package:flutter_template/presentation/widgets/loading_widgets.dart';
import 'package:flutter_template/presentation/widgets/error_state_widgets.dart';
import 'package:flutter_template/presentation/widgets/liked_card.dart';

// ============================================================================
// CONSTANTS
// ============================================================================
class _ProfilePageConstants {
  static double headerPadding = 11.w;
  static double contentPadding = 24.w;
  static double profilePhotoSize = 56.w;
  static const int gridCrossAxisCount = 2;
  static double gridCrossAxisSpacing = 16.w;
  static double gridMainAxisSpacing = 16.h;
  static const double gridChildAspectRatio = 169 / 251;
}

// ============================================================================
// MAIN PAGE
// ============================================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        getProfileUseCase: sl(),
        logoutUseCase: sl(),
        updateProfilePhotoUseCase: sl(),
        getFavoritesUseCase: sl(),
        toggleFavoriteUseCase: sl(),
      )..add(const ProfileLoadRequested()),
      child: const ProfileView(),
    );
  }
}

// ============================================================================
// PROFILE VIEW
// ============================================================================
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.bgGradientOf(context)),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            return switch (state.profileStatus) {
              ProfileStatus.initial => _buildLoadingState(),
              ProfileStatus.loading => _buildLoadingState(),
              ProfileStatus.success => state.user != null
                  ? _buildProfileContent(state, context)
                  : _buildEmptyUserState(context),
              ProfileStatus.failure => _buildEmptyUserState(context),
              ProfileStatus.loggedOut => _buildLoadingState(),
            };
          },
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ProfileState state) {
    final errorHandler = sl<ErrorHandler>();

    if (state.profileStatus == ProfileStatus.failure) {
      errorHandler.handleError(
        state.errorMessage,
        context: context,
      );
    }

    if (state.profileStatus == ProfileStatus.loggedOut) {
      // Login sayfasına yönlendir (error handler ile)
      errorHandler.handleError(
        context.l10n.sessionEnded,
        context: context,
      );
    }
  }

  /*
   * NOT: Gizli logout özelliği.
   * Profil fotoğrafına 2 saniye içinde 3 kere tıklanırsa logout olur.
   * Bu, UI'da logout butonu olmadan çıkış yapma imkanı sağlar.
   */
  void _handleProfilePhotoTap(BuildContext context) {
    final now = DateTime.now();

    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTapTime = now;

    if (_tapCount >= 3) {
      _tapCount = 0;
      _lastTapTime = null;
      context.read<ProfileBloc>().add(const ProfileLogoutRequested());
    }
  }

  Widget _buildLoadingState() {
    return const LoadingIndicator();
  }

  Widget _buildEmptyUserState(BuildContext context) {
    return EmptyStateView(
      icon: Icons.person_off_outlined,
      message: context.l10n.profileLoadFailed,
    );
  }

  Widget _buildProfileContent(ProfileState state, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(context),
      color: AppColors.primaryOf(context),
      backgroundColor: AppColors.bgDark,
      child: CustomScrollView(
        slivers: [
          _buildHeaderSection(context),
          _buildUserInfoCard(state, context),
          16.verticalSpace.sliverBox,
          _buildFavoritesTitle(context),
          24.verticalSpace.sliverBox,
          _buildFavoritesGrid(),
          SliverSafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: 16.h),
            sliver: SliverPadding(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    context.read<ProfileBloc>().add(const ProfileLoadRequested());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildSettingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSettingsSheet(context),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.white5,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.white20,
            width: 1.w,
          ),
        ),
        child: Icon(
          Icons.settings_outlined,
          color: AppColors.white,
          size: 20.w,
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ThemeCubit>()),
          BlocProvider.value(value: sl<LocaleCubit>()),
        ],
        child: const SettingsBottomSheet(),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final statusBarHeight = context.padding.top;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          _ProfilePageConstants.contentPadding.w,
          statusBarHeight + _ProfilePageConstants.headerPadding.h,
          _ProfilePageConstants.contentPadding.w,
          0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.profile,
              style: AppTypography.heading5.copyWith(
                color: AppColors.white,
              ),
            ),
            Row(
              children: [
                _buildSettingsButton(context),
                8.horizontalSpace,
                const _LimitedOfferBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(ProfileState state, BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _ProfilePageConstants.contentPadding.w,
          vertical: 11.h,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x1AFFFFFF), // ~10% white
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfilePhoto(state, context),
            8.horizontalSpace,
            _buildUserInfo(state),
            16.horizontalSpace,
            _buildPhotoUploadButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(ProfileState state, BuildContext context) {
    return GestureDetector(
      onTap: () => _handleProfilePhotoTap(context),
      child: ClipOval(
        child:
            state.user!.profilePhotoUrl != null &&
                state.user!.profilePhotoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: state.user!.profilePhotoUrl!,
                width: _ProfilePageConstants.profilePhotoSize.w,
                height: _ProfilePageConstants.profilePhotoSize.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPhotoPlaceholder(),
                errorWidget: (context, url, error) =>
                    _buildPhotoPlaceholder(),
              )
            : _buildPhotoPlaceholder(),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: _ProfilePageConstants.profilePhotoSize.w,
      height: _ProfilePageConstants.profilePhotoSize.w,
      color: AppColors.white10,
      child: Icon(Icons.person, color: AppColors.white50, size: 28.w),
    );
  }

  Widget _buildUserInfo(ProfileState state) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.user!.name,
            style: AppTypography.bodyLargeSemibold.copyWith(
              color: AppColors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          4.verticalSpace,
          Text(
            'ID: ${state.user!.id.substring(0, 6)}',
            style: AppTypography.bodyNormalMedium.copyWith(
              color: AppColors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPhotoSetup(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white5,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          context.l10n.addPhoto,
          style: AppTypography.bodyNormalSemibold.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToPhotoSetup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (newContext) => BlocProvider.value(
          value: context.read<ProfileBloc>(),
          child: const ProfilePhotoSetupPage(),
        ),
      ),
    );
  }

  Widget _buildFavoritesTitle(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _ProfilePageConstants.contentPadding.w,
        ),
        child: Text(
          context.l10n.favorites,
          style: AppTypography.bodyXLargeSemibold.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return switch (state.favoritesStatus) {
          FavoritesStatus.initial => _buildFavoritesLoadingState(context),
          FavoritesStatus.loading => _buildFavoritesLoadingState(context),
          FavoritesStatus.success => state.favorites.isEmpty
              ? _buildFavoritesEmptyState(context)
              : _buildFavoritesGridView(state),
          FavoritesStatus.failure => _buildFavoritesEmptyState(context),
        };
      },
    );
  }

  Widget _buildFavoritesLoadingState(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Center(
          child: LoadingIndicator(color: AppColors.primaryOf(context)),
        ),
      ),
    );
  }

  Widget _buildFavoritesEmptyState(BuildContext context) {
    return SliverEmptyState(
      icon: Icons.favorite_border,
      message: context.l10n.noFavorites,
      padding: EdgeInsets.symmetric(
        horizontal: _ProfilePageConstants.contentPadding.w,
        vertical: 32.h,
      ),
    );
  }

  Widget _buildFavoritesGridView(ProfileState state) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: _ProfilePageConstants.contentPadding.w,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _ProfilePageConstants.gridCrossAxisCount,
          crossAxisSpacing: _ProfilePageConstants.gridCrossAxisSpacing,
          mainAxisSpacing: _ProfilePageConstants.gridMainAxisSpacing,
          childAspectRatio: _ProfilePageConstants.gridChildAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final movie = state.favorites[index];
          return LikedCard(movie: movie);
        }, childCount: state.favorites.length),
      ),
    );
  }
}

// ============================================================================
// LIMITED OFFER BADGE
// ============================================================================
/// Profile sayfasında premium teklif badge'i
class _LimitedOfferBadge extends StatelessWidget {
  const _LimitedOfferBadge();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLimitedOfferBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFFB1030C)],
          ),
          borderRadius: BorderRadius.circular(53.r),
        ),
        child: Row(
          children: [
            SvgIcon(
              assetPath: AppIcons.gem,
              size: 20.w,
              color: AppColors.white,
            ),
            6.horizontalSpace,
            Text(
              context.l10n.limitedOffer,
              style: AppTypography.bodySmallSemibold.copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLimitedOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LimitedOfferBottomSheet(),
    );
  }
}
