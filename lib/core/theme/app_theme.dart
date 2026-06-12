import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const _primaryColor = Color(0xFFE53935);
  static const _secondaryColor = Color(0xFFD32F2F);
  static const _accentColor = Color(0xFFFF8A80);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        brightness: Brightness.light,
        surface: const Color(0xFFF8F9FA),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1A2E)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF0EFFF),
        selectedColor: _primaryColor,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0EFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: _primaryColor,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white);
          }
          return IconThemeData(color: Colors.grey.shade600);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(color: _primaryColor, fontWeight: FontWeight.bold);
          }
          return GoogleFonts.inter(color: Colors.grey.shade600, fontWeight: FontWeight.normal);
        }),
      ),
      extensions: [
        _CustomColors(
          breakingBadgeColor: _secondaryColor,
          categoryChipSelected: _primaryColor,
          shimmerBase: Colors.grey.shade200,
          shimmerHighlight: Colors.grey.shade100,
          cardOverlay: Colors.black.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

@immutable
class _CustomColors extends ThemeExtension<_CustomColors> {
  const _CustomColors({
    required this.breakingBadgeColor,
    required this.categoryChipSelected,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.cardOverlay,
  });

  final Color breakingBadgeColor;
  final Color categoryChipSelected;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color cardOverlay;

  @override
  _CustomColors copyWith({
    Color? breakingBadgeColor,
    Color? categoryChipSelected,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? cardOverlay,
  }) {
    return _CustomColors(
      breakingBadgeColor: breakingBadgeColor ?? this.breakingBadgeColor,
      categoryChipSelected: categoryChipSelected ?? this.categoryChipSelected,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      cardOverlay: cardOverlay ?? this.cardOverlay,
    );
  }

  @override
  _CustomColors lerp(_CustomColors? other, double t) {
    if (other is! _CustomColors) return this;
    return _CustomColors(
      breakingBadgeColor:
          Color.lerp(breakingBadgeColor, other.breakingBadgeColor, t)!,
      categoryChipSelected:
          Color.lerp(categoryChipSelected, other.categoryChipSelected, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      cardOverlay: Color.lerp(cardOverlay, other.cardOverlay, t)!,
    );
  }
}

