import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_template/core/initialization/app_initializer.dart';
import 'package:flutter_template/firebase_options.dart';

class FirebaseInitializationAdapter implements InitializationAdapter {
  @override
  String get name => 'Firebase Core';

  @override
  int get priority => 1;

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
