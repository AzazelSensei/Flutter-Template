import 'package:dio/dio.dart';
import 'package:flutter_template/core/constants/api_constants.dart';
import 'package:flutter_template/core/network/dio_client.dart';
import 'package:flutter_template/data/models/movie_model.dart';
import 'package:flutter_template/data/models/responses/movie_list_response.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListResponse> getMovieList({
    required int page,
    required int limit,
  });

  Future<List<MovieModel>> getFavorites();

  Future<void> toggleFavorite(String movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient dioClient;

  MovieRemoteDataSourceImpl(this.dioClient);

  @override
  Future<MovieListResponse> getMovieList({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.movieList,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200 && response.data != null) {
        return MovieListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  @override
  Future<List<MovieModel>> getFavorites() async {
    try {
      final response = await dioClient.dio.get(ApiConstants.favorites);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        /*
         * NOT: API'nin farklı formatlarda response döndürmesi durumunu handle ediyoruz:
         * Format 1: { "data": [...] }
         * Format 2: { "data": { "movies": [...] } }
         * Format 3: { "movies": [...] }
         * Format 4: [...] (direkt array)
         *
         * Backend tutarsızlığı nedeniyle tüm formatları destekliyoruz.
         */
        List<dynamic> moviesList;
        if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            moviesList = data['data'] as List<dynamic>;
          } else if (data['data'] is Map<String, dynamic>) {
            final unwrappedData = data['data'] as Map<String, dynamic>;
            moviesList = unwrappedData['movies'] ?? [];
          } else {
            moviesList = data['movies'] ?? [];
          }
        } else if (data is List) {
          moviesList = data;
        } else {
          throw Exception('Unexpected response format');
        }

        return moviesList
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String movieId) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.favoriteToggle(movieId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }
}
