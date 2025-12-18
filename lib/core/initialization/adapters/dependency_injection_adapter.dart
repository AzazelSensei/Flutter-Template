import 'package:flutter_template/core/di/injection_container.dart' as di;
import 'package:flutter_template/core/initialization/app_initializer.dart';

class DependencyInjectionAdapter implements InitializationAdapter {
  @override
  String get name => 'Dependency Injection (GetIt)';

  @override
  int get priority => 2;

  @override
  Future<void> initialize() async {
    await di.init();
  }
}
