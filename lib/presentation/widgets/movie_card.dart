import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                bottomLeft: Radius.circular(18.r),
              ),
              /*
               * CachedNetworkImage kullanımı:
               * - Image'ları cache'leyerek performansı artırır
               * - Placeholder: Loading state
               * - errorWidget: Hata durumu için fallback
               * - Memory ve disk cache otomatik
               */
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl,
                width: 120.w,
                height: 160.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 120.w,
                  height: 160.h,
                  color: Colors.white.withValues(alpha: 0.10),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFFE50914),
                      strokeWidth: 2.w,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 120.w,
                  height: 160.h,
                  color: Colors.white.withValues(alpha: 0.10),
                  child: Icon(
                    Icons.movie,
                    color: Colors.white.withValues(alpha: 0.50),
                    size: 40.w,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    6.verticalSpace,
                    Text(
                      movie.releaseYear,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.60),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    8.verticalSpace,
                    if (movie.genres.isNotEmpty)
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: movie.genres.take(3).map((genre) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFE50914,
                              ).withValues(alpha: 0.20),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: const Color(0xFFE50914),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    8.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFFFC107),
                          size: 16.w,
                        ),
                        4.horizontalSpace,
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onFavoriteToggle,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            movie.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: movie.isFavorite
                                ? const Color(0xFFE50914)
                                : Colors.white.withValues(alpha: 0.60),
                            size: 24.w,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
