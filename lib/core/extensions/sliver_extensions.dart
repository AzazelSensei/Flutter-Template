import 'package:flutter/material.dart';

// ============================================================================
// SLIVER EXTENSIONS
// ============================================================================
/// SizedBox ve diğer widget'lar için Sliver dönüşüm extension'ları

/// SizedBox'ı SliverToBoxAdapter'a dönüştürür
/// CustomScrollView/Sliver widget'lar içinde spacing için kullanışlıdır
///
/// Örnek kullanım:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverList(...),
///     16.verticalSpace.sliverBox,  // Spacing için
///     SliverGrid(...),
///   ],
/// )
/// ```
extension SliverBoxExtension on SizedBox {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}
