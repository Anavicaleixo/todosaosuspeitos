import 'package:flutter/material.dart';

class DeductionCard {
  final String id;
  final String title;
  final String typeTag; // ex: 'TESTEMUNHO', 'OBJETO', 'DOCUMENTO', 'HORÁRIO'
  final String frontDescription;
  final String backSecretNotes;
  final IconData icon;
  final bool isCorrect;

  const DeductionCard({
    required this.id,
    required this.title,
    required this.typeTag,
    required this.frontDescription,
    required this.backSecretNotes,
    required this.icon,
    this.isCorrect = false,
  });

  factory DeductionCard.fromJson(Map<String, dynamic> json) {
    return DeductionCard(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      typeTag: json['type_tag'] ?? 'EVIDÊNCIA',
      frontDescription: json['front_description'] ?? '',
      backSecretNotes: json['back_secret_notes'] ?? '',
      icon: _getIconData(json['icon_name']),
      isCorrect: json['is_correct'] ?? false,
    );
  }

  static IconData _getIconData(dynamic iconName) {
    switch (iconName) {
      case 'watch':
        return Icons.access_time;
      case 'key':
        return Icons.vpn_key;
      case 'fingerprint':
        return Icons.fingerprint;
      case 'letter':
        return Icons.mail_outline;
      case 'photo':
        return Icons.camera_alt_outlined;
      case 'footprint':
        return Icons.directions_walk;
      default:
        return Icons.find_in_page;
    }
  }
}
