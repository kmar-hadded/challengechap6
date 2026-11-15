import 'package:flutter/material.dart';

import '../models/contact_model.dart';

/// Écran 2 : résumé des données envoyées.
///
/// Le [ContactModel] arrive par les arguments de la route nommée
/// (voir `onGenerateRoute` dans `main.dart`).
class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key, required this.contact});

  static const String routeName = '/confirmation';

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          children: [
            Text(
              '🎉 Merci pour votre message !',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.dividerColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LigneResume(
                      icon: Icons.person_outline,
                      libelle: 'Nom',
                      valeur: contact.nom,
                    ),
                    const Divider(height: 24),
                    _LigneResume(
                      icon: Icons.email_outlined,
                      libelle: 'Email',
                      valeur: contact.email,
                    ),
                    const Divider(height: 24),
                    _LigneResume(
                      icon: Icons.phone_outlined,
                      libelle: 'Téléphone',
                      valeur: contact.aTelephone
                          ? contact.telephone
                          : 'Non renseigné',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Message :',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Text(
                contact.message,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 28),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Nouveau message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Une ligne « libellé : valeur » du résumé.
class _LigneResume extends StatelessWidget {
  const _LigneResume({
    required this.icon,
    required this.libelle,
    required this.valeur,
  });

  final IconData icon;
  final String libelle;
  final String valeur;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                libelle,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(valeur, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}