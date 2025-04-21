import 'package:flutter/material.dart';
import 'light_mode.dart';
import 'dark_mode.dart';

class ThemeProvider extends ChangeNotifier{

  // INITIALLY LIGHT MODE
  ThemeData _themeData = lightMode;

  // GET CURRENT THEME
  ThemeData get themeData => _themeData;

  // IS CURRENT THEME DARK MODE ?
  bool get isDarkMode => _themeData == darkMode;

  // SET THEME
  set themeData (ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  // TOGGLE METHOD FOR THEME
  void toggleTheme(){

    if(_themeData == lightMode){
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    notifyListeners();

  }
}


