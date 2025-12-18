import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_template/data/models/movie_model.dart';

part 'movie_list_response.freezed.dart';

@Freezed(fromJson: false)
class MovieListResponse with _$MovieListResponse {
  const factory MovieListResponse({
    required List<MovieModel> movies,
    required int totalPages,
    required int currentPage,
    int? totalCount,
    int? perPage,
  }) = _MovieListResponse;

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    /*
     * NOT: API'den gelen response yapısı iki farklı formatta olabilir:
     * 1. Wrapper yapısı: { "response": {...}, "data": {...} }
     * 2. Direkt data yapısı: { "movies": [...], "pagination": {...} }
     * Her iki durumu da handle ediyoruz.
     */
    if (json.containsKey('response') && json.containsKey('data')) {
      final data = json['data'];
      /*
       * Map formatı: /movie/list endpoint'i için
       * Pagination bilgisi ve movies listesi içerir
       */
      if (data is Map<String, dynamic>) {
        final moviesList = data['movies'] is List
            ? (data['movies'] as List)
                  .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
                  .toList()
            : <MovieModel>[];
        final pagination = data['pagination'] as Map<String, dynamic>?;

        if (pagination != null) {
          return MovieListResponse(
            movies: moviesList,
            totalPages: pagination['maxPage'] ?? 1,
            currentPage: pagination['currentPage'] ?? 1,
            totalCount: pagination['totalCount'],
            perPage: pagination['perPage'],
          );
        }
        return MovieListResponse(
          movies: moviesList,
          totalPages: 1,
          currentPage: 1,
        );
      }
      /*
       * List formatı: /movie/favorites endpoint'i için
       * Direkt movie listesi döner, pagination yok
       */
      if (data is List) {
        final moviesList = data
            .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return MovieListResponse(
          movies: moviesList,
          totalPages: 1,
          currentPage: 1,
        );
      }
    }
    /*
     * Fallback: Wrapper olmayan eski formatı işle
     */
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final moviesList = data['movies'] is List
        ? (data['movies'] as List)
              .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : data is List
        ? (data as List)
              .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : <MovieModel>[];
    final pagination = data['pagination'] as Map<String, dynamic>?;

    if (pagination != null) {
      return MovieListResponse(
        movies: moviesList,
        totalPages: pagination['maxPage'] ?? 1,
        currentPage: pagination['currentPage'] ?? 1,
        totalCount: pagination['totalCount'],
        perPage: pagination['perPage'],
      );
    }

    return MovieListResponse(movies: moviesList, totalPages: 1, currentPage: 1);
  }
}
