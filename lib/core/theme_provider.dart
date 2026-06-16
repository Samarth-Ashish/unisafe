//theme_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late bool isDark;
  late ThemeData currentTheme;

  ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light().copyWith(),
    //
    //
    // primarySwatch: Colors.red,
    // brightness: Brightness.light,
    // colorScheme: ColorScheme.fromSeed(
    //   seedColor: Colors.orangeAccent,
    //   brightness: Brightness.light,
    //   // primary: Colors.pink,
    //   // background: Colors.redAccent,
    // ),
    //
    //
    useMaterial3: true,
    // iconTheme: const IconThemeData(
    //   color: Colors.deepOrange,
    // ),
    // scaffoldBackgroundColor: Colors.red,
  );
  ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark().copyWith(
      
    ),
    // colorScheme: ColorScheme.fromSeed(
    //   seedColor: Colors.blue,
    //   brightness: Brightness.dark,
    //   // background: Colors.redAccent,
    // ),
    useMaterial3: true,
    // iconTheme: const IconThemeData(
    //   color: Colors.yellow,
    // ),
    // scaffoldBackgroundColor: Colors.green,
  );

  ThemeProvider() {
    isDark = false;
    currentTheme = lightTheme;
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? true;
    currentTheme = isDark ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }

  void toggleMode() async {
    isDark = !isDark;
    isDark ? setDarkmode() : setLightMode();
    saveThemePreference();
    notifyListeners();
  }

  void setLightMode() async {
    currentTheme = lightTheme;
    notifyListeners();
  }

  void setDarkmode() async {
    currentTheme = darkTheme;
    notifyListeners();
  }

  //

  Color? colorOfThemeBrightness(
    Color? color, [
    double amount = .1,
    Color? defaultColor,
  ]) {
    return isDark
        ? darken(color ?? defaultColor, amount)
        : lighten(color ?? defaultColor, amount);
  }

  Color? colorOfAntiThemeBrightness(Color? color,
      [double amount = .1, Color? defaultColor]) {
    return isDark
        ? lighten(color ?? defaultColor, amount)
        : darken(color ?? defaultColor, amount);
  }

  //

  Color? colorOfThemeBrightnessIfTrueAndViceVersa(bool condition, Color? color,
      [double amount = .1, Color? defaultColor]) {
    return condition
        ? colorOfThemeBrightness(color, amount, defaultColor)
        : colorOfAntiThemeBrightness(color, amount, defaultColor);
  }

  Color? colorOfAntiThemeBrightnessIfTrueAndViceVersa(
      bool condition, Color? color,
      [double amount = .1, Color? defaultColor]) {
    return condition
        ? colorOfAntiThemeBrightness(color, amount, defaultColor)
        : colorOfThemeBrightness(color, amount, defaultColor);
  }

  //

  Color? colorFromBrightnessOf(Color? color1, {Color color2 = Colors.grey}) {
    return returnColorFromBrightnessOf(
      fromColor: color1,
      colorToConvert: color2,
    );
  }
}

// ! darken/
Color? darken(Color? color, [double amount = .1]) {
  if (color == null) {
    return null;
  }

  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

// ! lighten
Color? lighten(Color? color, [double amount = .1]) {
  if (color == null) {
    return null;
  }

  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

// ! returnColorFromBrightnessOf
Color? returnColorFromBrightnessOf(
    {Color? fromColor, Color colorToConvert = Colors.grey}) {
  if (fromColor == null) {
    return null;
  }
  // colorToConvert = colorToConvert ?? Colors.grey;

  final fromColorHSL = HSLColor.fromColor(fromColor);
  final colorToConvertHSL = HSLColor.fromColor(colorToConvert);

  final hslBlended = HSLColor.fromAHSL(
    colorToConvert.alpha.toDouble(),
    colorToConvertHSL.hue,
    colorToConvertHSL.saturation,
    fromColorHSL.lightness,
  );

  return hslBlended.toColor();
}

//!themeModeSwitch
Widget themeModeSwitch(BuildContext context, ThemeProvider themeProvider) {
  return Switch(
    // inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
    // activeColor: Theme.of(context).colorScheme.onPrimary,
    //
    // inactiveTrackColor: Colors.black,
    // activeTrackColor: Colors.grey,
    //
    inactiveTrackColor: Colors.blue[900],
    // hoverColor: Colors.redAccent,
    // inactiveThumbColor: Colors.grey,
    activeTrackColor: Colors.orangeAccent,
    //
    value: !themeProvider.isDark,
    onChanged: (value) => themeProvider.toggleMode(),
  );
}


//themeSwitch
Widget themeSwitch(BuildContext context) {
  return Switch(
    // inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
    // activeColor: Theme.of(context).colorScheme.onPrimary,
    //
    // inactiveTrackColor: Colors.black,
    // activeTrackColor: Colors.grey,
    //
    inactiveTrackColor: const Color.fromARGB(255, 0, 36, 90),
    // hoverColor: Colors.redAccent,
    // inactiveThumbColor: Colors.grey,
    activeTrackColor: Colors.orangeAccent,
    //
    value: !context.watch<ThemeProvider>().isDark,
    // onChanged: (value) => themeProvider.toggleTheme(),
    onChanged: (value) => context.read<ThemeProvider>().toggleMode(),
  );
}

List<Widget> themeSwitchWithIcons(BuildContext context) {
  return [
    Icon(
      Icons.dark_mode,
      color: context.watch<ThemeProvider>().isDark ? Colors.blueAccent : null,
      size: 20,
    ),
    SizedBox(
      width: 50,
      child: FittedBox(
        fit: BoxFit.fill,
        child: themeSwitch(context),
      ),
    ),
    Icon(
      Icons.light_mode,
      color: context.watch<ThemeProvider>().isDark ? null : Colors.orangeAccent,
      size: 20,
    ),
  ];
}
