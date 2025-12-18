part of '../view/home_page.dart';

class _MoviePage extends StatefulWidget {
  final Movie movie;

  const _MoviePage({required this.movie});

  @override
  State<_MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<_MoviePage> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(),
        _buildPoster(),
        _buildGradientOverlay(),
        _buildMovieInfo(),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0.0),
          end: const Alignment(0.5, 1.0),
          colors: _HomePageConstants.backgroundGradient(context),
        ),
      ),
    );
  }

  Widget _buildPoster() {
    return Positioned.fill(
      child: widget.movie.posterUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: widget.movie.posterUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.black),
              errorWidget: (context, url, error) => _buildPosterError(),
            )
          : Container(color: AppColors.black),
    );
  }

  Widget _buildPosterError() {
    return Container(
      color: AppColors.black,
      child: Center(
        child: Icon(Icons.movie, color: AppColors.white30, size: 64.w),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: _HomePageConstants.overlayStops,
            colors: _HomePageConstants.overlayColors,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: _HomePageConstants.movieInfoBottom.h,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? null : _HomePageConstants.containerHeight.h,
        padding: EdgeInsets.only(
          top: 16.h,
          right: 43.79.w,
          bottom: 16.h,
          left: 24.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLogo(),
            16.horizontalSpace,
            _buildTitleAndDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryOf(context),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SvgPicture.asset(
        'assets/logo/Icon-white.svg',
        width: 20.38.w,
        height: 17.23.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return SizedBox(
      width: _HomePageConstants.movieInfoWidth.w,
      height: _isExpanded ? null : _HomePageConstants.movieInfoHeight.h,
      child: Column(
        mainAxisSize: _isExpanded ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          2.verticalSpace,
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.movie.title,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 18,
        fontFamily: 'Instrument Sans',
        fontWeight: FontWeight.w700,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Flexible(
      child: GestureDetector(
        onTap: _toggleExpanded,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: _isExpanded
                      ? '${widget.movie.description} '
                      : _truncateDescription(widget.movie.description),
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.80),
                    fontSize: 14.sp,
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: _isExpanded ? context.l10n.showLess : context.l10n.readMore,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            maxLines: _isExpanded ? null : 2,
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.clip,
          ),
        ),
      ),
    );
  }

  String _truncateDescription(String description) {
    if (description.length <= _HomePageConstants.descriptionMaxLength) {
      return '$description ';
    }
    return '${description.substring(0, _HomePageConstants.descriptionMaxLength)} ';
  }
}
