import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Application theme configuration.
class AppTheme {
  /// Dark background color used throughout the app.
  static const Color darkBackground = Color(0xFF181C25);

  /// Indicates if the app is running in debug or profile mode.
  static const bool isDebug = kDebugMode || kProfileMode;

  /// Returns the dark theme configuration.
  static ThemeData darkTheme({FlexScheme scheme = FlexScheme.shadBlue}) {
    return FlexThemeData.dark(
      scheme: scheme,
      scaffoldBackground: darkBackground,
      dialogBackground: darkBackground,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      useMaterial3ErrorColors: true,
      subThemesData: const FlexSubThemesData(
        // FAB
        fabUseShape: true,
        fabAlwaysCircular: true,
        // Chips
        chipBlendColors: true,
        chipRadius: 30,
        chipPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        chipSchemeColor: SchemeColor.primary,
        // InputDecorator
        inputSelectionSchemeColor: SchemeColor.primary,
        inputSelectionOpacity: 0.25,
        inputCursorSchemeColor: SchemeColor.primary,
        inputDecoratorSchemeColor: SchemeColor.tertiary,
        inputDecoratorIsFilled: true,
        inputDecoratorIsDense: true,
        inputDecoratorContentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        inputSelectionHandleSchemeColor: SchemeColor.primary,
        inputDecoratorBorderSchemeColor: SchemeColor.primary,
        inputDecoratorBorderWidth: 1.2,
        inputDecoratorFocusedBorderWidth: 1.2,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 12,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.onPrimaryFixedVariant,
        inputDecoratorSuffixIconSchemeColor: SchemeColor.onPrimaryFixedVariant,
        useInputDecoratorThemeInDialogs: true,
        inputDecoratorUnfocusedHasBorder: false,
        // TabBat
        tabBarDividerColor: Colors.transparent,
        tabBarItemSchemeColor: SchemeColor.primary,
        tabBarTabAlignment: TabAlignment.center,
        tabBarIndicatorSchemeColor: SchemeColor.primary,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
        tabBarIndicatorWeight: 3,
        tabBarIndicatorAnimation: TabIndicatorAnimation.linear,
        // BottomNavigation Bar
        bottomNavigationBarMutedUnselectedIcon: true,
        bottomNavigationBarMutedUnselectedLabel: true,
        bottomNavigationBarShowUnselectedLabels: false,
        bottomNavigationBarBackgroundSchemeColor: SchemeColor.secondaryContainer,
        // Switch
        switchThumbSchemeColor: SchemeColor.onPrimary,

        alignedDropdown: true,
        navigationRailUseIndicator: true,
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnColors: true,
        unselectedToggleIsColored: true,
        useM2StyleDividerInM3: true,
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: Colors.white),
        ),
        applyThemeToAll: true,
      ),
      visualDensity: VisualDensity.compact,
      splashFactory: InkRipple.splashFactory,
      fontFamily: 'Exo 2',
    ).copyWith(
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        dismissDirection: DismissDirection.horizontal,
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }

  /// Returns the light theme configuration.
  static ThemeData lightTheme({FlexScheme scheme = FlexScheme.shadBlue}) {
    return FlexThemeData.light(
      scheme: scheme,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      useMaterial3ErrorColors: true,
      subThemesData: const FlexSubThemesData(
        // FAB
        fabUseShape: true,
        fabAlwaysCircular: true,
        // Chips
        chipBlendColors: true,
        chipRadius: 30,
        chipPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        chipSchemeColor: SchemeColor.primary,
        // InputDecorator
        inputSelectionSchemeColor: SchemeColor.primary,
        inputSelectionOpacity: 0.25,
        inputCursorSchemeColor: SchemeColor.primary,
        inputDecoratorSchemeColor: SchemeColor.tertiary,
        inputDecoratorIsFilled: true,
        inputDecoratorIsDense: true,
        inputDecoratorContentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        inputSelectionHandleSchemeColor: SchemeColor.primary,
        inputDecoratorBorderSchemeColor: SchemeColor.primary,
        inputDecoratorBorderWidth: 1.2,
        inputDecoratorFocusedBorderWidth: 1.2,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 12,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.onPrimaryFixedVariant,
        inputDecoratorSuffixIconSchemeColor: SchemeColor.onPrimaryFixedVariant,
        useInputDecoratorThemeInDialogs: true,
        inputDecoratorUnfocusedHasBorder: false,
        // TabBat
        tabBarDividerColor: Colors.transparent,
        tabBarItemSchemeColor: SchemeColor.primary,
        tabBarTabAlignment: TabAlignment.center,
        tabBarIndicatorSchemeColor: SchemeColor.primary,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
        tabBarIndicatorWeight: 3,
        tabBarIndicatorAnimation: TabIndicatorAnimation.linear,
        // BottomNavigation Bar
        bottomNavigationBarMutedUnselectedIcon: true,
        bottomNavigationBarMutedUnselectedLabel: true,
        bottomNavigationBarShowUnselectedLabels: false,
        bottomNavigationBarBackgroundSchemeColor: SchemeColor.secondaryContainer,
        // Switch
        switchThumbSchemeColor: SchemeColor.onPrimary,

        alignedDropdown: true,
        navigationRailUseIndicator: true,
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnColors: true,
        unselectedToggleIsColored: true,
        useM2StyleDividerInM3: true,
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        applyThemeToAll: true,
      ),
      visualDensity: VisualDensity.compact,
      splashFactory: InkRipple.splashFactory,
      fontFamily: 'Exo 2',
    ).copyWith(
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        dismissDirection: DismissDirection.horizontal,
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
