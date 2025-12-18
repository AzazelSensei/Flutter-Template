import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String releaseYear;
  final double rating;
  final List<String> genres;
  final bool isFavorite;
  final String country;
  final String? rated;
  final String? released;
  final String? runtime;
  final String? director;
  final String? writer;
  final String? actors;
  final String? language;
  final String? awards;
  final String? metascore;
  final String? imdbVotes;
  final String? imdbId;
  final String? type;
  final List<String>? images;
  final bool? comingSoon;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.releaseYear,
    required this.rating,
    required this.genres,
    required this.isFavorite,
    required this.country,
    this.rated,
    this.released,
    this.runtime,
    this.director,
    this.writer,
    this.actors,
    this.language,
    this.awards,
    this.metascore,
    this.imdbVotes,
    this.imdbId,
    this.type,
    this.images,
    this.comingSoon,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    String? releaseYear,
    double? rating,
    List<String>? genres,
    bool? isFavorite,
    String? country,
    String? rated,
    String? released,
    String? runtime,
    String? director,
    String? writer,
    String? actors,
    String? language,
    String? awards,
    String? metascore,
    String? imdbVotes,
    String? imdbId,
    String? type,
    List<String>? images,
    bool? comingSoon,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      releaseYear: releaseYear ?? this.releaseYear,
      rating: rating ?? this.rating,
      genres: genres ?? this.genres,
      isFavorite: isFavorite ?? this.isFavorite,
      country: country ?? this.country,
      rated: rated ?? this.rated,
      released: released ?? this.released,
      runtime: runtime ?? this.runtime,
      director: director ?? this.director,
      writer: writer ?? this.writer,
      actors: actors ?? this.actors,
      language: language ?? this.language,
      awards: awards ?? this.awards,
      metascore: metascore ?? this.metascore,
      imdbVotes: imdbVotes ?? this.imdbVotes,
      imdbId: imdbId ?? this.imdbId,
      type: type ?? this.type,
      images: images ?? this.images,
      comingSoon: comingSoon ?? this.comingSoon,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        posterUrl,
        releaseYear,
        rating,
        genres,
        isFavorite,
        country,
        rated,
        released,
        runtime,
        director,
        writer,
        actors,
        language,
        awards,
        metascore,
        imdbVotes,
        imdbId,
        type,
        images,
        comingSoon,
      ];
}
