import 'crime_card_model.dart';
import 'case_model.dart';

enum MissionType {
  chemicalTest,     // Análise Forense de Reagente no app
  cipherDecode,     // Decodificação de Cifra / Código no app
  alibiCrossCheck,  // Cruzamento de Depoimentos / Contradição no app
}

class InAppMission {
  final String id;
  final String title;
  final MissionType type;
  final String forensicClueDocument; // O documento / laudo coletado com as pistas explícitas
  final String description;
  final String challengeQuestion;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String unlockedCardTitle;
  final List<String> unlocksCardIds;
  final int points;
  final bool isCompleted;

  const InAppMission({
    required this.id,
    required this.title,
    required this.type,
    required this.forensicClueDocument,
    required this.description,
    required this.challengeQuestion,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.unlockedCardTitle,
    required this.unlocksCardIds,
    this.points = 75,
    this.isCompleted = false,
  });

  InAppMission copyWith({bool? isCompleted}) {
    return InAppMission(
      id: id,
      title: title,
      type: type,
      forensicClueDocument: forensicClueDocument,
      description: description,
      challengeQuestion: challengeQuestion,
      options: options,
      correctOptionIndex: correctOptionIndex,
      explanation: explanation,
      unlockedCardTitle: unlockedCardTitle,
      unlocksCardIds: unlocksCardIds,
      points: points,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class CriminalCaseModel {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String victim;
  final String crimeScene;
  final String timeOfCrime;
  final String synopsis;
  final int rewardPoints;
  final double mapX;
  final double mapY;
  final List<String> parentCaseIds;
  final bool isRoot;
  final CaseStatus status;

  // Mecânica do Jogo de Cartas
  final List<InAppMission> inAppMissions;
  final List<CrimeCard> cards;
  final String solutionSuspectId;   // 1. O Acusado Culpado
  final String solutionWeaponId;    // 2. A Arma Utilizada
  final String solutionLocationId;  // 3. O Local Real do Crime
  final String solutionEvidenceId;  // 4. O Vestígio Decisivo
  final String crimeResolutionStory;

  const CriminalCaseModel({
    required this.id,
    required this.title,
    required this.category,
    this.difficulty = 'Difícil',
    required this.victim,
    required this.crimeScene,
    required this.timeOfCrime,
    required this.synopsis,
    this.rewardPoints = 250,
    required this.mapX,
    required this.mapY,
    this.parentCaseIds = const [],
    this.isRoot = false,
    this.status = CaseStatus.locked,
    required this.inAppMissions,
    required this.cards,
    required this.solutionSuspectId,
    required this.solutionWeaponId,
    required this.solutionLocationId,
    required this.solutionEvidenceId,
    required this.crimeResolutionStory,
  });

  CriminalCaseModel copyWith({
    CaseStatus? status,
    List<InAppMission>? inAppMissions,
  }) {
    return CriminalCaseModel(
      id: id,
      title: title,
      category: category,
      difficulty: difficulty,
      victim: victim,
      crimeScene: crimeScene,
      timeOfCrime: timeOfCrime,
      synopsis: synopsis,
      rewardPoints: rewardPoints,
      mapX: mapX,
      mapY: mapY,
      parentCaseIds: parentCaseIds,
      isRoot: isRoot,
      status: status ?? this.status,
      inAppMissions: inAppMissions ?? this.inAppMissions,
      cards: cards,
      solutionSuspectId: solutionSuspectId,
      solutionWeaponId: solutionWeaponId,
      solutionLocationId: solutionLocationId,
      solutionEvidenceId: solutionEvidenceId,
      crimeResolutionStory: crimeResolutionStory,
    );
  }
}
