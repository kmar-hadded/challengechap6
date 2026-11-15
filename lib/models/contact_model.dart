/// Modèle de données du formulaire de contact.
///
/// Immuable : une fois le formulaire validé, on crée une instance que l'on
/// transmet à la page de confirmation via les arguments de la route nommée.
class ContactModel {
  final String nom;
  final String email;
  final String telephone;
  final String message;

  const ContactModel({
    required this.nom,
    required this.email,
    required this.message,
    this.telephone = '',
  });

  /// Le téléphone est le seul champ optionnel du formulaire.
  bool get aTelephone => telephone.trim().isNotEmpty;

  ContactModel copyWith({
    String? nom,
    String? email,
    String? telephone,
    String? message,
  }) {
    return ContactModel(
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      message: message ?? this.message,
    );
  }

  /// Sérialisation (pratique pour un envoi vers une API ou un stockage local).
  Map<String, dynamic> toMap() => {
        'nom': nom,
        'email': email,
        'telephone': telephone,
        'message': message,
      };

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        nom: map['nom'] as String? ?? '',
        email: map['email'] as String? ?? '',
        telephone: map['telephone'] as String? ?? '',
        message: map['message'] as String? ?? '',
      );

  @override
  String toString() =>
      'ContactModel(nom: $nom, email: $email, telephone: $telephone, '
      'message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactModel &&
          other.nom == nom &&
          other.email == email &&
          other.telephone == telephone &&
          other.message == message;

  @override
  int get hashCode => Object.hash(nom, email, telephone, message);
}