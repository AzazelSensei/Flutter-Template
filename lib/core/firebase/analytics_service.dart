import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  Future<void> initialize() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  Future<void> logLogin({String? method}) async {
    await _analytics.logLogin(loginMethod: method ?? 'email');
  }

  Future<void> logSignUp({String? method}) async {
    await _analytics.logSignUp(signUpMethod: method ?? 'email');
  }

  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  Future<void> logMovieView({
    required String movieId,
    required String movieTitle,
  }) async {
    await _analytics.logEvent(
      name: 'movie_view',
      parameters: {'movie_id': movieId, 'movie_title': movieTitle},
    );
  }

  Future<void> logAddToFavorites({
    required String movieId,
    required String movieTitle,
  }) async {
    await _analytics.logEvent(
      name: 'add_to_favorites',
      parameters: {'movie_id': movieId, 'movie_title': movieTitle},
    );
  }

  Future<void> logRemoveFromFavorites({
    required String movieId,
    required String movieTitle,
  }) async {
    await _analytics.logEvent(
      name: 'remove_from_favorites',
      parameters: {'movie_id': movieId, 'movie_title': movieTitle},
    );
  }

  Future<void> logError({
    required String errorType,
    String? errorMessage,
    bool fatal = false,
  }) async {
    await _analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage ?? 'Unknown error',
        'fatal': fatal,
      },
    );
  }

  Future<void> logThemeChange(String themeName) async {
    await _analytics.logEvent(
      name: 'theme_change',
      parameters: {'theme': themeName},
    );
  }

  Future<void> logLanguageChange(String languageCode) async {
    await _analytics.logEvent(
      name: 'language_change',
      parameters: {'language': languageCode},
    );
  }

  Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }

  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  Future<void> clearUserId() async {
    await _analytics.setUserId(id: null);
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  bool get isEnabled => true;
}
