import 'package:flutter/material.dart';
import 'package:flutter_template/core/extensions/context_extensions.dart';
import 'package:flutter_template/presentation/home/view/home_page.dart';
import 'package:flutter_template/presentation/profile/view/profile_page.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';
import 'package:flutter_template/presentation/widgets/custom_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      /*
       * IndexedStack kullanımı:
       * - Tüm sayfalar memory'de tutulur (state korunur)
       * - Sayfa geçişlerinde rebuild olmaz (performans artışı)
       * - Home'daki scroll pozisyonu, Profile'a gidip gelince kaybolmaz
       */
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavItem(
            icon: AppIcons.home,
            iconFill: AppIcons.homeFill,
            label: context.l10n.home,
          ),
          BottomNavItem(
            icon: AppIcons.profile,
            iconFill: AppIcons.profileFill,
            label: context.l10n.profile,
          ),
        ],
      ),
    );
  }
}
