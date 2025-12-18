import 'package:flutter/material.dart';
import 'package:flutter_template/core/di/injection_container.dart';
import 'package:flutter_template/core/storage/token_storage.dart';
import 'package:flutter_template/presentation/auth/view/login_page_new.dart';
import 'package:flutter_template/presentation/main/view/main_page.dart';
import 'package:flutter_template/presentation/widgets/loading_widgets.dart';

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final tokenStorage = sl<TokenStorage>();
    final hasToken = await tokenStorage.hasToken();

    /*
     * CRITICAL: mounted kontrolü
     * Async işlem bitmeden widget dispose olmuş olabilir
     * mounted=false ise context kullanımı crash'e sebep olur
     */
    if (!mounted) return;

    if (hasToken) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPageNew()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const GradientLoadingPage();
  }
}
