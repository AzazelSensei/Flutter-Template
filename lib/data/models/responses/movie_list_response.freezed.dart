// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MovieListResponse {
  List<MovieModel> get movies => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int? get totalCount => throw _privateConstructorUsedError;
  int? get perPage => throw _privateConstructorUsedError;

  /// Create a copy of MovieListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovieListResponseCopyWith<MovieListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieListResponseCopyWith<$Res> {
  factory $MovieListResponseCopyWith(
    MovieListResponse value,
    $Res Function(MovieListResponse) then,
  ) = _$MovieListResponseCopyWithImpl<$Res, MovieListResponse>;
  @useResult
  $Res call({
    List<MovieModel> movies,
    int totalPages,
    int currentPage,
    int? totalCount,
    int? perPage,
  });
}

/// @nodoc
class _$MovieListResponseCopyWithImpl<$Res, $Val extends MovieListResponse>
    implements $MovieListResponseCopyWith<$Res> {
  _$MovieListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MovieListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? movies = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? totalCount = freezed,
    Object? perPage = freezed,
  }) {
    return _then(
      _value.copyWith(
            movies: null == movies
                ? _value.movies
                : movies // ignore: cast_nullable_to_non_nullable
                      as List<MovieModel>,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCount: freezed == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            perPage: freezed == perPage
                ? _value.perPage
                : perPage // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MovieListResponseImplCopyWith<$Res>
    implements $MovieListResponseCopyWith<$Res> {
  factory _$$MovieListResponseImplCopyWith(
    _$MovieListResponseImpl value,
    $Res Function(_$MovieListResponseImpl) then,
  ) = __$$MovieListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<MovieModel> movies,
    int totalPages,
    int currentPage,
    int? totalCount,
    int? perPage,
  });
}

/// @nodoc
class __$$MovieListResponseImplCopyWithImpl<$Res>
    extends _$MovieListResponseCopyWithImpl<$Res, _$MovieListResponseImpl>
    implements _$$MovieListResponseImplCopyWith<$Res> {
  __$$MovieListResponseImplCopyWithImpl(
    _$MovieListResponseImpl _value,
    $Res Function(_$MovieListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MovieListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? movies = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? totalCount = freezed,
    Object? perPage = freezed,
  }) {
    return _then(
      _$MovieListResponseImpl(
        movies: null == movies
            ? _value._movies
            : movies // ignore: cast_nullable_to_non_nullable
                  as List<MovieModel>,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCount: freezed == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        perPage: freezed == perPage
            ? _value.perPage
            : perPage // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$MovieListResponseImpl implements _MovieListResponse {
  const _$MovieListResponseImpl({
    required final List<MovieModel> movies,
    required this.totalPages,
    required this.currentPage,
    this.totalCount,
    this.perPage,
  }) : _movies = movies;

  final List<MovieModel> _movies;
  @override
  List<MovieModel> get movies {
    if (_movies is EqualUnmodifiableListView) return _movies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_movies);
  }

  @override
  final int totalPages;
  @override
  final int currentPage;
  @override
  final int? totalCount;
  @override
  final int? perPage;

  @override
  String toString() {
    return 'MovieListResponse(movies: $movies, totalPages: $totalPages, currentPage: $currentPage, totalCount: $totalCount, perPage: $perPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieListResponseImpl &&
            const DeepCollectionEquality().equals(other._movies, _movies) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.perPage, perPage) || other.perPage == perPage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_movies),
    totalPages,
    currentPage,
    totalCount,
    perPage,
  );

  /// Create a copy of MovieListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieListResponseImplCopyWith<_$MovieListResponseImpl> get copyWith =>
      __$$MovieListResponseImplCopyWithImpl<_$MovieListResponseImpl>(
        this,
        _$identity,
      );
}

abstract class _MovieListResponse implements MovieListResponse {
  const factory _MovieListResponse({
    required final List<MovieModel> movies,
    required final int totalPages,
    required final int currentPage,
    final int? totalCount,
    final int? perPage,
  }) = _$MovieListResponseImpl;

  @override
  List<MovieModel> get movies;
  @override
  int get totalPages;
  @override
  int get currentPage;
  @override
  int? get totalCount;
  @override
  int? get perPage;

  /// Create a copy of MovieListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovieListResponseImplCopyWith<_$MovieListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
