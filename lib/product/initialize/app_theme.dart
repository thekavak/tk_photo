import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/app_color.dart';

class AppTheme {
  AppTheme();

  ThemeData get themeData => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: ColorConstants.mtPrimary,
          secondary: ColorConstants.mtPrimary.withOpacity(0.5),
          error: Colors.red,
          onPrimary: ColorConstants.mtPrimary,
          onSecondary: ColorConstants.mtPrimary.withOpacity(0.6),
          onError: ColorConstants.mtPrimary,
          surface: ColorConstants.mtPrimary,
          onSurface: ColorConstants.mtPrimary,
          background: Colors.grey.shade100,
          onBackground: Colors.white,
        ),
        textTheme: GoogleFonts.ibmPlexSansTextTheme().copyWith(
          displayLarge: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w800,
            fontSize: 36,
            letterSpacing: 1,
            wordSpacing: 1,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: 0.5,
            wordSpacing: 1,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: 0.5,
            wordSpacing: 1,
            color: Colors.black,
          ),
          bodySmall: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            letterSpacing: 0.5,
            wordSpacing: 1,
            color: Colors.black,
          ),
          labelMedium: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            wordSpacing: 1,
            color: Colors.black,
          ),
          labelLarge: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            wordSpacing: 1,
            color: Colors.black,
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          surfaceTintColor: Colors.transparent,
          backgroundColor: ColorConstants.mtPrimary,
        ),
        scaffoldBackgroundColor: Colors.white,
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          overlayColor: WidgetStateProperty.all(
            ColorConstants.mtPrimary.withOpacity(0.2),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          isDense: true,
          labelStyle: TextStyle(color: Colors.black, fontSize: 16),
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 2, color: ColorConstants.mtPrimary),
          ),
          fillColor: Colors.white,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 2, color: ColorConstants.mtPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 2, color: ColorConstants.mtPrimary),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
            elevation: WidgetStateProperty.all(0),
            overlayColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.2)),
            backgroundColor: WidgetStateProperty.all(
              ColorConstants.mtPrimary,
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: ColorConstants.mtPrimary,
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            overlayColor:
                WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        // useMaterial3: true,
      );
}
