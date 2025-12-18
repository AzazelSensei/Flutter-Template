import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/domain/entities/movie.dart';
import 'package:flutter_template/domain/entities/user.dart';
import 'package:flutter_template/domain/usecases/auth/get_profile_usecase.dart';
import 'package:flutter_template/domain/usecases/auth/logout_usecase.dart';
import 'package:flutter_template/domain/usecases/auth/update_profile_photo_usecase.dart';
import 'package:flutter_template/domain/usecases/movie/get_favorites_usecase.dart';
import 'package:flutter_template/domain/usecases/movie/toggle_favorite_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateProfilePhotoUseCase updateProfilePhotoUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.logoutUseCase,
    required this.updateProfilePhotoUseCase,
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(const ProfileState()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfilePhotoUpdateRequested>(_onPhotoUpdateRequested);
    on<ProfileLogoutRequested>(_onLogoutRequested);
    on<FavoritesLoadRequested>(_onFavoritesLoadRequested);
    on<FavoriteRemoveRequested>(_onFavoriteRemoveRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(profileStatus: ProfileStatus.loading));

      final result = await getProfileUseCase(NoParams());

      result.fold(
        (failure) => emit(state.copyWith(
          profileStatus: ProfileStatus.failure,
          errorMessage: failure.message,
        )),
        (user) {
          emit(state.copyWith(
            profileStatus: ProfileStatus.success,
            user: user,
          ));
          add(const FavoritesLoadRequested());
        },
      );
    } catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPhotoUpdateRequested(
    ProfilePhotoUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(profileStatus: ProfileStatus.loading));

      final result = await updateProfilePhotoUseCase(
        UpdateProfilePhotoParams(photoPath: event.photoPath),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          profileStatus: ProfileStatus.failure,
          errorMessage: failure.message,
        )),
        (user) => emit(state.copyWith(
          profileStatus: ProfileStatus.success,
          user: user,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await logoutUseCase(NoParams());
      emit(state.copyWith(profileStatus: ProfileStatus.loggedOut));
    } catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFavoritesLoadRequested(
    FavoritesLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(favoritesStatus: FavoritesStatus.loading));

      final result = await getFavoritesUseCase(NoParams());

      result.fold(
        (failure) => emit(state.copyWith(
          favoritesStatus: FavoritesStatus.failure,
          errorMessage: failure.message,
        )),
        (favorites) => emit(state.copyWith(
          favoritesStatus: FavoritesStatus.success,
          favorites: favorites,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        favoritesStatus: FavoritesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFavoriteRemoveRequested(
    FavoriteRemoveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final result = await toggleFavoriteUseCase(
        ToggleFavoriteParams(movieId: event.movieId),
      );

      /*
       * Favorilerden film kaldırma işlemi.
       * Başarılı olursa yerel state'ten de filmi çıkarıyoruz,
       * böylece kullanıcı anında sonucu görür.
       */
      result.fold(
        (failure) {},
        (_) {
          final updatedFavorites = state.favorites
              .where((movie) => movie.id != event.movieId)
              .toList();

          emit(state.copyWith(favorites: updatedFavorites));
        },
      );
    } catch (e) {
      // Catch silently - favorite removal errors don't need to block UI
    }
  }
}
