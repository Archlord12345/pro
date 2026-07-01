import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGreen = Color(0xFF076633);
  static const Color deepBlue = Color(0xFF2B2E83);
  static const Color skyBlue = Color(0xFF009FE3);
  static const Color yellow = Color(0xFFFDC500);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2F5FB);
  static const Color border = Color(0xFFE1E8F5);
  static const Color success = Color(0xFF1D9E65);

  static const Color primary = deepBlue;
  static const Color secondary = darkGreen;
  static const Color accent = skyBlue;
  static const Color warning = yellow;
  static const Color background = Color(0xFFF6F8FC);
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF667085);
  static const Color cardPurple = deepBlue;
  static const Color cardTeal = skyBlue;
  static const Color cardOrange = yellow;
  static const Color cardPink = Color(0xFFE63946);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [deepBlue, skyBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [skyBlue, darkGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF172554), Color(0xFF1D4ED8), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = primaryGradient;
  static const LinearGradient tealGradient = accentGradient;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    fontFamily: 'Poppins',
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    color: AppColors.textSecondary,
    height: 1.5,
    fontFamily: 'Poppins',
  );
}

class AppBreakpoints {
  static const double mobile = 640;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double wide = 1440;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= wide) {
      return const EdgeInsets.symmetric(horizontal: 72, vertical: 32);
    }
    if (width >= desktop) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 28);
    }
    if (width >= mobile) {
      return const EdgeInsets.symmetric(horizontal: 28, vertical: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 20);
  }

  static double contentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= wide) return 1280;
    if (width >= desktop) return 1100;
    return width;
  }
}

class AppDecorations {
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.08),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static BoxDecoration card({
    Color color = AppColors.surface,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(28)),
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      border: border ?? Border.all(color: AppColors.border),
      boxShadow: softShadow,
    );
  }
}
