
// ============================================
// 📁 lib/utils/validators.dart
// ============================================
import 'package:medical/screens/signin_screen.dart';

class Validators {
  static bool validateEmailOrPhone(String value, bool isPhone, CountryCode country) {
    if (isPhone) {
      switch (country) {
        case CountryCode.togo:
          return RegExp(r'^[9][0-1][0-9]{6}$').hasMatch(value) && value.length == 8;
        case CountryCode.france:
          return RegExp(r'^[6-7][0-9]{8}$').hasMatch(value) && value.length == 9;
        case CountryCode.usa:
          return RegExp(r'^[2-9][0-9]{9}$').hasMatch(value) && value.length == 10;
      }
    }
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  static bool validatePassword(String password) {
    // Version améliorée avec règles de complexité
    if (password.length < 8) return false;
    
    // Au moins une lettre majuscule
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    
    // Au moins une lettre minuscule
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    
    // Au moins un chiffre
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    
    return true;
  }

  static bool validateFullName(String name) {
    return name.trim().length >= 3 && RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$').hasMatch(name);
  }
}
