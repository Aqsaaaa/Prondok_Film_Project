import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p9_basket_project/gen/colors.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Styles {
  static ThemeData themeData(bool isDarkMode, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:
          isDarkMode ? const Color(0xFF262626) : Colors.white,
      primaryColor: isDarkMode ? Colors.white : Colors.black,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      appBarTheme: AppBarTheme(
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkMode ? const Color(0xFF262626) : Colors.white,
        selectedItemColor:
            isDarkMode ? Colors.white : Color.fromARGB(241, 23, 29, 75),
      ),
      iconTheme: IconThemeData(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      cardTheme: CardTheme(
          color: isDarkMode ? const Color(0xFF2171D4B) : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(
            color: isDarkMode ? ColorName.primary : ColorName.white,
          ))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: isDarkMode
                  ? const Color(0xFF272727)
                  : const Color(0xFFFFFFFF),
              foregroundColor: isDarkMode ? Colors.white : ColorName.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: isDarkMode ? Colors.black : ColorName.primary),
              ))),
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme.apply(
              bodyColor: isDarkMode ? Colors.white : Colors.black,
              displayColor: isDarkMode ? Colors.white : Colors.black,
            ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: isDarkMode ? Colors.white : ColorName.primary,
        unselectedLabelColor: isDarkMode ? Colors.white70 : Colors.black54,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? Colors.white : ColorName.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class ThemePrefs {
  // ignore: constant_identifier_names
  static const String THEME_TYPE = 'THEMETYPE';

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_TYPE, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_TYPE) ?? false;
  }
}

class ThemeProvider with ChangeNotifier {
  ThemePrefs themePrefs = ThemePrefs();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    themePrefs.setDarkTheme(value);
    notifyListeners();
  }
}
