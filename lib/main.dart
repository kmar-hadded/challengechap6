import 'package:flutter/material.dart';

import 'models/contact_model.dart';
import 'screens/confirmation_page.dart';
import 'screens/contact_form.dart';

void main() => runApp(const ContactApp());

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact',
      debugShowCheckedModeBanner: false,
      theme: _theme(),

      // ------------------------------------------------ routes nommées
      initialRoute: ContactForm.routeName,
      routes: {
        ContactForm.routeName: (_) => const ContactForm(),
      },

      // La page de confirmation attend un argument typé : on la construit
      // ici pour vérifier l'argument avant d'afficher l'écran.
      onGenerateRoute: (settings) {
        if (settings.name == ConfirmationPage.routeName) {
          final argument = settings.arguments;
          if (argument is! ContactModel) {
            return _routeErreur(
              settings,
              'La page de confirmation attend un ContactModel en argument.',
            );
          }
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ConfirmationPage(contact: argument),
          );
        }
        return null; // laisse `routes` et `onUnknownRoute` faire leur travail
      },

      onUnknownRoute: (settings) => _routeErreur(
        settings,
        'Route introuvable : ${settings.name}',
      ),
    );
  }

  static Route<void> _routeErreur(RouteSettings settings, String message) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Erreur de navigation')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  static ThemeData _theme() {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1B3B6F));

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFCF6FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      // Style commun à tous les champs du formulaire.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: colorScheme.primary,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}