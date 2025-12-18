part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure, loggedOut }
enum FavoritesStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final FavoritesStatus favoritesStatus;
  final User? user;
  final List<Movie> favorites;
  final String? errorMessage;

  const ProfileState({
    this.profileStatus = ProfileStatus.initial,
    this.favoritesStatus = FavoritesStatus.initial,
    this.user,
    this.favorites = const [],
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    FavoritesStatus? favoritesStatus,
    User? user,
    List<Movie>? favorites,
    String? errorMessage,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      favoritesStatus: favoritesStatus ?? this.favoritesStatus,
      user: user ?? this.user,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        profileStatus,
        favoritesStatus,
        user,
        favorites,
        errorMessage,
      ];
}
