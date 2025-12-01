// The theme design of the app
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:conversaition/features/common/themes/color_schemes.dart';
import 'package:conversaition/features/common/themes/text_theme.dart';

sealed class AppTheme {
  // select the used theme, based on brightness
  static ThemeData use(BuildContext context, Brightness brightness) {
    // check if theme is light or dark
    final bool isLight = brightness == Brightness.light;

    // get color schme based on brightness
    final ColorScheme colorScheme = isLight
        ? AppColorScheme.light
        : AppColorScheme.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      typography: Typography.material2021(
        platform: defaultTargetPlatform,
        colorScheme: colorScheme,
      ),
      appBarTheme: AppBarTheme(backgroundColor: colorScheme.primaryContainer),
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //   backgroundColor: colorScheme.primary,
      //   foregroundColor: colorScheme.onPrimary,
      // ),
      // navigationBarTheme: NavigationBarThemeData(
      //   backgroundColor: isLight ? colorScheme.surface : null,
      //   indicatorColor: colorScheme.primary,
      //   labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      //   iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
      //     if (states.contains(WidgetState.selected)) {
      //       return IconThemeData(color: colorScheme.onPrimary);
      //     }
      //     return IconThemeData(color: colorScheme.onSurface);
      //   }),
      // ),
      textTheme: createTextTheme(context, "Roboto", "Merriweather"),
      scaffoldBackgroundColor: isLight ? colorScheme.surfaceBright : null,
    );
  }
}
