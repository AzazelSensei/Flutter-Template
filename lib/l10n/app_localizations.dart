import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Shartflix'**
  String get appName;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Error occurred message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No content available message
  ///
  /// In en, this message translates to:
  /// **'No content yet'**
  String get noContentYet;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Sign up prompt text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Login prompt text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Registration error message
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// Password mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// Session expired message
  ///
  /// In en, this message translates to:
  /// **'Your session has ended'**
  String get sessionEnded;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in with your credentials'**
  String get loginSubtitle;

  /// Invalid email validation error
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Name length validation error
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Favorites section title
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get favorites;

  /// Add photo button text
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// Empty favorites message
  ///
  /// In en, this message translates to:
  /// **'No favorite movies yet'**
  String get noFavorites;

  /// Unknown studio fallback text
  ///
  /// In en, this message translates to:
  /// **'Unknown Studio'**
  String get unknownStudio;

  /// Limited offer badge text
  ///
  /// In en, this message translates to:
  /// **'Limited Offer'**
  String get limitedOffer;

  /// Limited offer description text
  ///
  /// In en, this message translates to:
  /// **'Choose a token package to earn bonuses and unlock new chapters!'**
  String get limitedOfferDescription;

  /// Spotlight bonus label
  ///
  /// In en, this message translates to:
  /// **'Spotlight'**
  String get spotlight;

  /// More likes bonus label
  ///
  /// In en, this message translates to:
  /// **'More Likes'**
  String get moreLikes;

  /// Profile load error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load user profile'**
  String get profileLoadFailed;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Movies tab title
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// Series tab title
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Empty movies list message
  ///
  /// In en, this message translates to:
  /// **'No movies found'**
  String get noMovies;

  /// No movies available message
  ///
  /// In en, this message translates to:
  /// **'No movies yet'**
  String get noMoviesYet;

  /// Load more button text
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme selection header
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// Language selection header
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Current theme label
  ///
  /// In en, this message translates to:
  /// **'Current Theme'**
  String get currentTheme;

  /// Current language label
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// Red theme name
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get redTheme;

  /// Blue theme name
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blueTheme;

  /// Green theme name
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get greenTheme;

  /// Purple theme name
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purpleTheme;

  /// Orange theme name
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orangeTheme;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection.'**
  String get networkError;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// Unexpected error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// Authentication error message
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Please login again.'**
  String get authenticationError;

  /// Social login divider text
  ///
  /// In en, this message translates to:
  /// **'or continue with:'**
  String get orContinueWith;

  /// Google login button text
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get googleLogin;

  /// Apple login button text
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get appleLogin;

  /// Facebook login button text
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get facebookLogin;

  /// Register page title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Register page subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up with your information'**
  String get registerSubtitle;

  /// Upload photo page title
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// Upload photo page description
  ///
  /// In en, this message translates to:
  /// **'You can upload an image for your profile photo'**
  String get uploadPhotoDescription;

  /// Profile details page title
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileDetails;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Photo selection error message
  ///
  /// In en, this message translates to:
  /// **'Photo selection failed'**
  String get photoSelectionError;

  /// Bonuses section title
  ///
  /// In en, this message translates to:
  /// **'Your Bonuses'**
  String get yourBonuses;

  /// Premium account bonus label
  ///
  /// In en, this message translates to:
  /// **'Premium Account'**
  String get premiumAccount;

  /// More matches bonus label
  ///
  /// In en, this message translates to:
  /// **'More Matches'**
  String get moreMatches;

  /// Token package selection instruction
  ///
  /// In en, this message translates to:
  /// **'Select a token package to unlock'**
  String get selectTokenPackage;

  /// See all tokens button text
  ///
  /// In en, this message translates to:
  /// **'See All Tokens'**
  String get seeAllTokens;

  /// Terms checkbox prefix text
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the '**
  String get termsPrefix;

  /// Terms checkbox highlighted text
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get termsAccept;

  /// Terms checkbox suffix text
  ///
  /// In en, this message translates to:
  /// **'. Please read this agreement before continuing.'**
  String get termsSuffix;

  /// Show less button text
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// Read more button text
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// Token label
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// Per week label
  ///
  /// In en, this message translates to:
  /// **'Per week'**
  String get perWeek;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
