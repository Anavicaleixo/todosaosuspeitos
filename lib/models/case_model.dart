import 'stage_model.dart';

enum CaseStatus {
  locked,
  unlocked, // Disponível com "Novo!"
  completed, // Resolvido
}

class CaseModel {
  final String id;
  final String title;
  final String synopsis;
  final String category;
  final String difficulty;
  final int rewardPoints;
  final double mapX;
  final double mapY;
  final List<String> parentCaseIds;
  final bool isRoot;
  final CaseStatus status;
  final int currentStageOrder;
  final List<StageModel> stages;

  const CaseModel({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.category,
    this.difficulty = 'Normal',
    this.rewardPoints = 100,
    required this.mapX,
    required this.mapY,
    this.parentCaseIds = const [],
    this.isRoot = false,
    this.status = CaseStatus.locked,
    this.currentStageOrder = 1,
    this.stages = const [],
  });

  CaseModel copyWith({
    CaseStatus? status,
    int? currentStageOrder,
    List<StageModel>? stages,
  }) {
    return CaseModel(
      id: id,
      title: title,
      synopsis: synopsis,
      category: category,
      difficulty: difficulty,
      rewardPoints: rewardPoints,
      mapX: mapX,
      mapY: mapY,
      parentCaseIds: parentCaseIds,
      isRoot: isRoot,
      status: status ?? this.status,
      currentStageOrder: currentStageOrder ?? this.currentStageOrder,
      stages: stages ?? this.stages,
    );
  }

  factory CaseModel.fromJson(Map<String, dynamic> json, {CaseStatus status = CaseStatus.locked, int currentStage = 1, List<StageModel> stages = const []}) {
    return CaseModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      synopsis: json['synopsis'] ?? '',
      category: json['category'] ?? 'Geral',
      difficulty: json['difficulty'] ?? 'Normal',
      rewardPoints: json['reward_points'] ?? 100,
      mapX: (json['map_x'] as num?)?.toDouble() ?? 0.0,
      mapY: (json['map_y'] as num?)?.toDouble() ?? 0.0,
      parentCaseIds: (json['parent_case_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isRoot: json['is_root'] ?? false,
      status: status,
      currentStageOrder: currentStage,
      stages: stages,
    );
  }
}
