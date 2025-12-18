import 'package:flutter_template/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.description,
    required super.posterUrl,
    required super.releaseYear,
    required super.rating,
    required super.genres,
    required super.isFavorite,
    required super.country,
    super.rated,
    super.released,
    super.runtime,
    super.director,
    super.writer,
    super.actors,
    super.language,
    super.awards,
    super.metascore,
    super.imdbVotes,
    super.imdbId,
    super.type,
    super.images,
    super.comingSoon,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    /*
     * NOT: Poster URL'lerini normalize ediyoruz.
     * HTTP'yi HTTPS'e çeviriyoruz (güvenlik için).
     */
    var posterUrl = json['Poster'] ?? json['posterUrl'] ?? json['poster_url'] ?? '';
    if (posterUrl is String && posterUrl.startsWith('http://')) {
      posterUrl = posterUrl.replaceFirst('http://', 'https://');
    }

    double rating = 0.0;
    if (json['imdbRating'] != null) {
      rating = json['imdbRating'] is String
          ? double.tryParse(json['imdbRating']) ?? 0.0
          : (json['imdbRating'] as num).toDouble();
    } else if (json['rating'] != null) {
      rating = json['rating'] is String
          ? double.tryParse(json['rating']) ?? 0.0
          : (json['rating'] as num).toDouble();
    }

    List<String> genres = [];
    if (json['Genre'] != null && json['Genre'] is String) {
      genres = (json['Genre'] as String)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (json['genres'] != null && json['genres'] is List) {
      genres = List<String>.from(json['genres']);
    }

    List<String>? images;
    if (json['Images'] != null && json['Images'] is List) {
      try {
        images = List<String>.from(json['Images']);
      } catch (e) {
        images = null;
      }
    } else if (json['images'] != null && json['images'] is List) {
      try {
        images = List<String>.from(json['images']);
      } catch (e) {
        images = null;
      }
    }

    return MovieModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['Title']?.toString() ?? json['title']?.toString() ?? '',
      description: json['Plot']?.toString() ?? json['description']?.toString() ?? json['plot']?.toString() ?? '',
      posterUrl: posterUrl,
      releaseYear: json['Year']?.toString() ?? json['releaseYear']?.toString() ?? json['release_year']?.toString() ?? '',
      rating: rating,
      genres: genres,
      isFavorite: json['isFavorite'] ?? json['is_favorite'] ?? false,
      country: json['Country']?.toString() ?? json['country']?.toString() ?? '',
      rated: json['Rated']?.toString() ?? json['rated']?.toString(),
      released: json['Released']?.toString() ?? json['released']?.toString(),
      runtime: json['Runtime']?.toString() ?? json['runtime']?.toString(),
      director: json['Director']?.toString() ?? json['director']?.toString(),
      writer: json['Writer']?.toString() ?? json['writer']?.toString(),
      actors: json['Actors']?.toString() ?? json['actors']?.toString(),
      language: json['Language']?.toString() ?? json['language']?.toString(),
      awards: json['Awards']?.toString() ?? json['awards']?.toString(),
      metascore: json['Metascore']?.toString() ?? json['metascore']?.toString(),
      imdbVotes: json['imdbVotes']?.toString() ?? json['imdb_votes']?.toString(),
      imdbId: json['imdbID']?.toString() ?? json['imdbId']?.toString() ?? json['imdb_id']?.toString(),
      type: json['Type']?.toString() ?? json['type']?.toString(),
      images: images,
      comingSoon: json['ComingSoon'] ?? json['comingSoon'] ?? json['coming_soon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Title': title,
      'Plot': description,
      'Poster': posterUrl,
      'Year': releaseYear,
      'imdbRating': rating.toString(),
      'Genre': genres.join(', '),
      'isFavorite': isFavorite,
      'Country': country,
      if (rated != null) 'Rated': rated,
      if (released != null) 'Released': released,
      if (runtime != null) 'Runtime': runtime,
      if (director != null) 'Director': director,
      if (writer != null) 'Writer': writer,
      if (actors != null) 'Actors': actors,
      if (language != null) 'Language': language,
      if (awards != null) 'Awards': awards,
      if (metascore != null) 'Metascore': metascore,
      if (imdbVotes != null) 'imdbVotes': imdbVotes,
      if (imdbId != null) 'imdbID': imdbId,
      if (type != null) 'Type': type,
      if (images != null) 'Images': images,
      if (comingSoon != null) 'ComingSoon': comingSoon,
    };
  }

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      description: description,
      posterUrl: posterUrl,
      releaseYear: releaseYear,
      rating: rating,
      genres: genres,
      isFavorite: isFavorite,
      country: country,
      rated: rated,
      released: released,
      runtime: runtime,
      director: director,
      writer: writer,
      actors: actors,
      language: language,
      awards: awards,
      metascore: metascore,
      imdbVotes: imdbVotes,
      imdbId: imdbId,
      type: type,
      images: images,
      comingSoon: comingSoon,
    );
  }
}
