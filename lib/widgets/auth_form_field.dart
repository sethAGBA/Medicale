
// ============================================
// 📁 lib/widgets/auth_form_field.dart
// ============================================
// Widget réutilisable pour le champ email/téléphone
import 'package:flutter/widgets.dart';
import 'package:medical/screens/signin_screen.dart';

class AuthEmailOrPhoneField extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final bool usePhoneNumber;
  final CountryCode selectedCountry;
  final Function(bool) onToggle;
  final Function(CountryCode) onCountryChanged;

  const AuthEmailOrPhoneField({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.usePhoneNumber,
    required this.selectedCountry,
    required this.onToggle,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Implémentation similaire au code actuel mais refactorisée
    // ... (code du widget)
    return Container(); // Placeholder
  }
}

class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    // Implémentation du champ mot de passe
    return Container(); // Placeholder
  }
}