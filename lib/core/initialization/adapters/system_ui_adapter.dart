import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/core/initialization/app_initializer.dart';


class SystemUIAdapter implements InitializationAdapter {
  @override
  String get name => 'System UI Configuration';

  @override
  int get priority => 5;

  @override
  Future<void> initialize() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    // Sadece portrait mode
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
