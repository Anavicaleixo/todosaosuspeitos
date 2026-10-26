import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/case_model.dart';
import '../models/profile_model.dart';
import '../models/criminal_case_model.dart';
import '../data/criminal_cases_data.dart';

class SupabaseService extends ChangeNotifier {
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  ProfileModel _profile = const ProfileModel(
    id: 'demo_user',
    username: 'DetetiveNoir',
    fullName: 'Inspetor J. Vance',
    badgeTitle: 'Perito Criminal de Homicídios',
    detectiveLevel: 1,
    totalScore: 150,
    streakDays: 4,
  );

  List<CriminalCaseModel> _criminalCases = CriminalCasesData.getInitialCases();
  final Set<String> _unlockedCardIds = {
    // Suspeitos iniciais
    'card_suspect_beatrice',
    'card_suspect_arthur',
    'card_suspect_julian',
    'card_suspect_advogado',
    // 1 de cada outra categoria liberado de início para visualização
    'card_weapon_dagger',
    'card_loc_library',
    'card_ev_torn_will',
  };

  ProfileModel get profile => _profile;
  List<CriminalCaseModel> get criminalCases => _criminalCases;
  List<CriminalCaseModel> get cases => _criminalCases;
  Set<String> get unlockedCardIds => _unlockedCardIds;
  User? get currentUser => _client?.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  bool isCardUnlocked(String cardId) {
    return _unlockedCardIds.contains(cardId);
  }

  // Cumpre uma missão interativa no próprio app e destrava as cartas
  Future<void> completeInAppMission(CriminalCaseModel currentCase, InAppMission mission) async {
    _unlockedCardIds.addAll(mission.unlocksCardIds);

    final newScore = _profile.totalScore + mission.points;
    final newLevel = (newScore / 250).floor() + 1;
    _profile = _profile.copyWith(
      totalScore: newScore,
      detectiveLevel: newLevel,
      badgeTitle: _getBadgeForLevel(newLevel),
      streakDays: _profile.streakDays + 1,
    );

    _criminalCases = _criminalCases.map((c) {
      if (c.id == currentCase.id) {
        final updatedMissions = c.inAppMissions.map((m) {
          if (m.id == mission.id) {
            return m.copyWith(isCompleted: true);
          }
          return m;
        }).toList();
        return c.copyWith(inAppMissions: updatedMissions);
      }
      return c;
    }).toList();

    notifyListeners();
  }

  // Acusação Final com as 4 Cartas Selecionadas (Suspeito + Arma + Local + Vestígio)
  Map<String, dynamic> verifyDeduction({
    required CriminalCaseModel caseData,
    required String suspectCardId,
    required String weaponCardId,
    required String locationCardId,
    required String evidenceCardId,
  }) {
    final bool suspectCorrect = suspectCardId == caseData.solutionSuspectId;
    final bool weaponCorrect = weaponCardId == caseData.solutionWeaponId;
    final bool locationCorrect = locationCardId == caseData.solutionLocationId;
    final bool evidenceCorrect = evidenceCardId == caseData.solutionEvidenceId;

    if (suspectCorrect && weaponCorrect && locationCorrect && evidenceCorrect) {
      final newScore = _profile.totalScore + caseData.rewardPoints;
      final newLevel = (newScore / 250).floor() + 1;
      _profile = _profile.copyWith(
        totalScore: newScore,
        detectiveLevel: newLevel,
        badgeTitle: _getBadgeForLevel(newLevel),
      );

      _criminalCases = _criminalCases.map((c) {
        if (c.id == caseData.id) {
          return c.copyWith(status: CaseStatus.completed);
        }
        return c;
      }).toList();

      _recalculateUnlocks();
      notifyListeners();

      return {
        'success': true,
        'message': 'CASO TOTALMENTE SOLUCIONADO!',
        'story': caseData.crimeResolutionStory,
      };
    }

    // Feedback inteligente com base na categoria que falhou
    String hint = '';
    if (!suspectCorrect) {
      hint = 'CONTRADIÇÃO NO ACUSADO: O suspeito indicado possui álibi corroborado por testemunhas externas ou registros oficiais.';
    } else if (!weaponCorrect) {
      hint = 'CONTRADIÇÃO NA ARMA: O laudo toxicológico não encontrou vestígios da substância selecionada no organismo da vítima.';
    } else if (!locationCorrect) {
      hint = 'CONTRADIÇÃO NO LOCAL: O impacto no relógio de bolso e os vestígios botânicos provam que a vítima não sofreu o ataque neste local.';
    } else {
      hint = 'CONTRADIÇÃO NO VESTÍGIO: A evidência forense selecionada é circunstancial e não vincula diretamente o assassino à cena primária.';
    }

    return {
      'success': false,
      'message': 'ACUSAÇÃO REJEITADA PELA PERÍCIA',
      'hint': hint,
    };
  }

  void _recalculateUnlocks() {
    final completedIds = _criminalCases
        .where((c) => c.status == CaseStatus.completed)
        .map((c) => c.id)
        .toSet();

    _criminalCases = _criminalCases.map((c) {
      if (c.status == CaseStatus.completed) return c;
      if (c.isRoot) return c.copyWith(status: CaseStatus.unlocked);

      final allParentsDone = c.parentCaseIds.isNotEmpty &&
          c.parentCaseIds.every((parentId) => completedIds.contains(parentId));

      if (allParentsDone) {
        return c.copyWith(status: CaseStatus.unlocked);
      }
      return c.copyWith(status: CaseStatus.locked);
    }).toList();
  }

  String _getBadgeForLevel(int level) {
    if (level >= 5) return 'Superintendente Chefe';
    if (level >= 4) return 'Inspetor de Homicídios Sênior';
    if (level >= 3) return 'Perito Criminal Forense';
    if (level >= 2) return 'Investigador de Cena de Crime';
    return 'Detetive Assistente';
  }

  Future<void> signUp({required String email, required String password, required String username}) async {
    final client = _client;
    if (client == null) return;
    await client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username, 'full_name': 'Agente $username'},
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    final client = _client;
    if (client == null) return;
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    final client = _client;
    if (client != null) {
      await client.auth.signOut();
    }
  }
}
