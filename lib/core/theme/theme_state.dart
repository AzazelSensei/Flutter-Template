import 'package:equatable/equatable.dart';
import 'package:flutter_template/domain/entities/app_theme.dart';

class ThemeState extends Equatable {
  final AppTheme currentTheme;

  const ThemeState({
    this.currentTheme = AppTheme.netflixRed,
  });

  ThemeState copyWith({
    AppTheme? currentTheme,
  }) {
    return ThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }

  @override
  List<Object?> get props => [currentTheme];
}
