import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/domain/entities/movie.dart';

/// Movie card for displaying liked/favorite movies
///
/// Favori film kartı - poster, başlık ve yıl bilgisi gösterir.
/// Grid layout'larda kullanılır.
class LikedCard extends StatelessWidget {
  final Movie movie;

  const LikedCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMoviePoster(),
        16.verticalSpace,
        _buildMovieTitle(),
        4.verticalSpace,
        _buildMovieStudio(context),
      ],
    );
  }

  Widget _buildMoviePoster() {
    return SizedBox(
      width: double.infinity,
      height: 196.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CachedNetworkImage(
          imageUrl: movie.posterUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.white10,
      child: Center(
        child: Icon(Icons.movie, color: AppColors.white30, size: 40.w),
      ),
    );
  }

  Widget _buildMovieTitle() {
    return Text(
      movie.title,
      style: AppTypography.bodySmallSemibold.copyWith(color: AppColors.white),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMovieStudio(BuildContext context) {
    return Text(
      movie.releaseYear.isNotEmpty
          ? movie.releaseYear
          : context.l10n.unknownStudio,
      style: AppTypography.bodySmallRegular.copyWith(
        color: AppColors.white50,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
