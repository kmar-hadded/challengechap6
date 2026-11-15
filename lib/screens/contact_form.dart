import 'package:flutter/material.dart';

import '../models/contact_model.dart';
import 'confirmation_page.dart';

/// Écran 1 : le formulaire de contact.
///
/// - un [Form] piloté par une [GlobalKey] pour déclencher la validation ;
/// - des champs personnalisés réutilisables ([CustomTextField]) ;
/// - navigation par route nommée avec passage d'un [ContactModel] en argument.
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  static const String routeName = '/';

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _messageController = TextEditingController();

  /// Tant que l'utilisateur n'a pas appuyé sur « Envoyer », on n'affiche
  /// aucune erreur. Ensuite, la validation se fait à chaque frappe.
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- validation

  String? _validerNom(String? value) {
    final nom = value?.trim() ?? '';
    if (nom.isEmpty) return 'Le nom est requis';
    if (nom.length < 3) return 'Le nom doit contenir au moins 3 caractères';
    return null;
  }

  String? _validerEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return "L'email est requis";
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]{2,}$');
    if (!regex.hasMatch(email)) return "Format d'email invalide";
    return null;
  }

  String? _validerTelephone(String? value) {
    final tel = value?.trim() ?? '';
    if (tel.isEmpty) return null; // champ optionnel
    final regex = RegExp(r'^\+?[\d\s]{8,15}$');
    if (!regex.hasMatch(tel)) return 'Numéro de téléphone invalide';
    return null;
  }

  String? _validerMessage(String? value) {
    final message = value?.trim() ?? '';
    if (message.isEmpty) return 'Message requis';
    if (message.length < 10) {
      return 'Le message doit contenir au moins 10 caractères';
    }
    return null;
  }

  // ---------------------------------------------------------------- soumission

  Future<void> _envoyer() async {
    FocusScope.of(context).unfocus();

    final estValide = _formKey.currentState?.validate() ?? false;
    if (!estValide) {
      // On active la validation continue pour guider l'utilisateur.
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    final contact = ContactModel(
      nom: _nomController.text.trim(),
      email: _emailController.text.trim(),
      telephone: _telephoneController.text.trim(),
      message: _messageController.text.trim(),
    );

    // Route nommée + argument fortement typé.
    await Navigator.pushNamed(
      context,
      ConfirmationPage.routeName,
      arguments: contact,
    );

    if (!mounted) return;
    _reinitialiser();
  }

  void _reinitialiser() {
    _formKey.currentState?.reset();
    _nomController.clear();
    _emailController.clear();
    _telephoneController.clear();
    _messageController.clear();
    setState(() => _autovalidateMode = AutovalidateMode.disabled);
  }

  // --------------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              CustomTextField(
                controller: _nomController,
                label: 'Nom',
                icon: Icons.person_outline,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validerNom,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validerEmail,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _telephoneController,
                label: 'Téléphone',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _validerTelephone,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _messageController,
                label: 'Message',
                icon: Icons.chat_bubble_outline,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 4,
                validator: _validerMessage,
              ),
              const SizedBox(height: 28),
              Center(
                child: ElevatedButton(
                  onPressed: _envoyer,
                  child: const Text('Envoyer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Champ de saisie personnalisé : une seule définition pour les quatre champs.
///
/// Gère l'icône de préfixe (alignée en haut pour les champs multilignes),
/// le clavier, l'action clavier et le validateur.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int maxLines;

  bool get _estMultiligne => maxLines > 1;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: _estMultiligne,
        prefixIcon: _estMultiligne
            // L'icône est poussée vers le haut du champ multiligne.
            ? Padding(
                padding: EdgeInsets.only(bottom: 22.0 * (maxLines - 1)),
                child: Icon(icon),
              )
            : Icon(icon),
      ),
    );
  }
}