part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileLogoutRequested extends ProfileEvent {
  const ProfileLogoutRequested();
}

class ProfilePhotoUpdateRequested extends ProfileEvent {
  final String photoPath;

  const ProfilePhotoUpdateRequested(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}

class FavoritesLoadRequested extends ProfileEvent {
  const FavoritesLoadRequested();
}

class FavoriteRemoveRequested extends ProfileEvent {
  final String movieId;

  const FavoriteRemoveRequested(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
