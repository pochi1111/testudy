import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFF3F3F3);

final appTheme = ThemeData(
  fontFamily: 'Noto Sans JP',
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff000000),
    surfaceTint: Color(0xff000000),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffffffff),
    onPrimaryContainer: Color(0xff000000),
    secondary: Color(0xff000000),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color.fromARGB(255, 0, 0, 0),
    onSecondaryContainer: Color.fromARGB(255, 255, 255, 255),
    tertiary: Color(0xff000000),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xff000000),
    onTertiaryContainer: Color(0xffffffff),
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff410002),
    surface: Color(0xffffffff),
    onSurface: Color(0xff000000),
    onSurfaceVariant: Color(0xff000000),
    outline: Color(0xff000000),
    outlineVariant: Color(0xff000000),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff000000),
    inversePrimary: Color(0xffffffff),
    primaryFixed: Color(0xffffffff),
    onPrimaryFixed: Color(0xff000000),
    primaryFixedDim: Color(0xffffffff),
    onPrimaryFixedVariant: Color(0xff000000),
    secondaryFixed: Color(0xffffffff),
    onSecondaryFixed: Color(0xff000000),
    secondaryFixedDim: Color(0xffffffff),
    onSecondaryFixedVariant: Color(0xff000000),
    tertiaryFixed: Color(0xffffffff),
    onTertiaryFixed: Color(0xff000000),
    tertiaryFixedDim: Color(0xffffffff),
    onTertiaryFixedVariant: Color(0xff000000),
    surfaceDim: Color(0xffffffff),
    surfaceBright: Color(0xffffffff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xffffffff),
    surfaceContainer: Color(0xffffffff),
    surfaceContainerHigh: Color(0xffffffff),
    surfaceContainerHighest: Color(0xffffffff),
  ),
);

class AppBarTitle extends StatelessWidget {
  final String title;
  const AppBarTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 25,
      ),
    );
  }
}
