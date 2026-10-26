class ProfileModel {
  final String id;
  final String username;
  final String fullName;
  final String badgeTitle;
  final int detectiveLevel;
  final int totalScore;
  final int streakDays;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.fullName,
    this.badgeTitle = 'Detetive Novato',
    this.detectiveLevel = 1,
    this.totalScore = 0,
    this.streakDays = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? 'Detetive',
      fullName: json['full_name'] ?? 'Agente Não Identificado',
      badgeTitle: json['badge_title'] ?? 'Detetive Novato',
      detectiveLevel: json['detective_level'] ?? 1,
      totalScore: json['total_score'] ?? 0,
      streakDays: json['streak_days'] ?? 0,
    );
  }

  ProfileModel copyWith({
    String? username,
    String? fullName,
    String? badgeTitle,
    int? detectiveLevel,
    int? totalScore,
    int? streakDays,
  }) {
    return ProfileModel(
      id: id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      badgeTitle: badgeTitle ?? this.badgeTitle,
      detectiveLevel: detectiveLevel ?? this.detectiveLevel,
      totalScore: totalScore ?? this.totalScore,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}
