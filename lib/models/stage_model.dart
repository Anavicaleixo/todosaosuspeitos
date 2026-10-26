import 'deduction_card_model.dart';

class StageModel {
  final String id;
  final String caseId;
  final int stageOrder;
  final String title;
  final String realWorldTask;
  final String clueRevelation;
  final int points;
  final bool isFinalStage;
  final String deductionRiddle;
  final List<DeductionCard> cards;

  const StageModel({
    required this.id,
    required this.caseId,
    required this.stageOrder,
    required this.title,
    required this.realWorldTask,
    required this.clueRevelation,
    this.points = 50,
    this.isFinalStage = false,
    this.deductionRiddle = 'Selecione a carta de evidência compatível com as marcas registradas.',
    this.cards = const [],
  });

  factory StageModel.fromJson(Map<String, dynamic> json) {
    var rawCards = json['cards'] as List<dynamic>? ?? [];
    List<DeductionCard> loadedCards = rawCards
        .map((c) => DeductionCard.fromJson(c as Map<String, dynamic>))
        .toList();

    return StageModel(
      id: json['id']?.toString() ?? '',
      caseId: json['case_id']?.toString() ?? '',
      stageOrder: json['stage_order'] ?? 1,
      title: json['title'] ?? '',
      realWorldTask: json['real_world_task'] ?? '',
      clueRevelation: json['clue_revelation'] ?? '',
      points: json['points'] ?? 50,
      isFinalStage: json['is_final_stage'] ?? false,
      deductionRiddle: json['deduction_riddle'] ?? 'Selecione a carta que desvenda o enigma.',
      cards: loadedCards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'case_id': caseId,
      'stage_order': stageOrder,
      'title': title,
      'real_world_task': realWorldTask,
      'clue_revelation': clueRevelation,
      'points': points,
      'is_final_stage': isFinalStage,
      'deduction_riddle': deductionRiddle,
    };
  }
}
