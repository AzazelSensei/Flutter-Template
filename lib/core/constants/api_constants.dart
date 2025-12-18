class ApiConstants {
  static const String baseUrl = 'https://caseapi.servicelabs.tech';

  static const String register = '/user/register';
  static const String login = '/user/login';
  static const String profile = '/user/profile';
  static const String uploadPhoto = '/user/upload_photo';

  static const String movieList = '/movie/list';
  static const String favorites = '/movie/favorites';
  static String favoriteToggle(String movieId) => '/movie/favorite/$movieId';
}
