// The ColorScheme made from SeedColorScheme.fromSeeds.
// Using flex_color_scheme package by Mike Rydstrom rydmike

// Here we map our app color design tokens to the SeedColorScheme.fromSeeds
// key colors and pin color tokens to selected ColorScheme colors.
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:conversaition/features/common/themes/theme_tokens.dart';

sealed class AppColorScheme {
  // Light ColorScheme
  static final ColorScheme light = SeedColorScheme.fromSeeds(
    brightness: Brightness.light,
    primaryKey: ThemeTokens.springSky,
    secondaryKey: ThemeTokens.dentistGreen,
    tertiaryKey: ThemeTokens.pinkRash,
    errorKey: ThemeTokens.raspberry,
    neutralKey: ThemeTokens.lightestGrey,
    // We use the tones chroma that has colorfulness that is fully driven
    // by the given key colors' chromacity.
    tones: FlexTones.chroma(Brightness.light),
    // Color overrides to design token values.
    primary: ThemeTokens.springSky,
    secondary: ThemeTokens.dentistGreen,
    tertiary: ThemeTokens.pinkRash,
  );

  // Dark ColorScheme
  static final ColorScheme dark = SeedColorScheme.fromSeeds(
    brightness: Brightness.dark,
    primaryKey: ThemeTokens.springSky,
    secondaryKey: ThemeTokens.dentistGreen,
    tertiaryKey: ThemeTokens.pinkRash,
    errorKey: ThemeTokens.raspberry,
    neutralKey: ThemeTokens.darkerGrey,
    // We use the tones chroma that has colorfulness that is fully driven
    // by the given key colors' chromacity.
    tones: FlexTones.chroma(Brightness.dark),
  );
}
