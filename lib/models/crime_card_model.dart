import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum CardType {
  suspect,  // Acusado
  weapon,   // Arma / Método
  location, // Local da Cena
  evidence, // Vestígio Forense
}

class CrimeCard {
  final String id;
  final String title;
  final String subtitle;
  final CardType type;
  final String description;
  final String secretClue; // Detalhe revelado ao virar a carta em 3D
  final IconData icon;
  final bool isKeyClue;    // Se é a carta correta na solução do crime

  const CrimeCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.description,
    required this.secretClue,
    required this.icon,
    this.isKeyClue = false,
  });

  String get typeLabel {
    switch (type) {
      case CardType.suspect:
        return 'ACUSADO';
      case CardType.weapon:
        return 'ARMA DO CRIME';
      case CardType.location:
        return 'LOCAL DA CENA';
      case CardType.evidence:
        return 'VESTÍGIO FORENSE';
    }
  }

  Color get typeColor {
    switch (type) {
      case CardType.suspect:
        return AppColors.typeSuspect;
      case CardType.weapon:
        return AppColors.typeWeapon;
      case CardType.location:
        return AppColors.typeLocation;
      case CardType.evidence:
        return AppColors.typeEvidence;
    }
  }
}
