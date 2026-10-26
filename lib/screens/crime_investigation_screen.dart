import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/criminal_case_model.dart';
import '../models/crime_card_model.dart';
import '../services/supabase_service.dart';
import '../core/constants/app_colors.dart';
import '../widgets/crime_card_item_widget.dart';

class CrimeInvestigationScreen extends StatefulWidget {
  final CriminalCaseModel caseData;

  const CrimeInvestigationScreen({super.key, required this.caseData});

  @override
  State<CrimeInvestigationScreen> createState() => _CrimeInvestigationScreenState();
}

class _CrimeInvestigationScreenState extends State<CrimeInvestigationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 4 Dimensões Forenses para Acusação
  String? _selectedSuspectId;
  String? _selectedWeaponId;
  String? _selectedLocationId;
  String? _selectedEvidenceId;

  String? _accusationFeedback;
  bool _isAccusationSuccess = false;
  String? _resolutionStory;

  // Mapa de opções selecionadas por missão {missionId: optionIndex}
  final Map<String, int> _selectedOptions = {};
  final Map<String, String?> _missionFeedbacks = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<SupabaseService>();
    final currentCase = service.criminalCases.firstWhere(
      (c) => c.id == widget.caseData.id,
      orElse: () => widget.caseData,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.goldBright),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.wineBright,
          indicatorWeight: 3,
          labelColor: AppColors.goldBright,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.style, size: 18), text: 'BARALHO DE CARTAS'),
            Tab(icon: Icon(Icons.psychology, size: 18), text: 'DESAFIOS FORENSES NO SITE'),
            Tab(icon: Icon(Icons.gavel, size: 18), text: 'MESA DE ACUSAÇÃO (4 CARTAS)'),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentCase.title.toUpperCase(),
              style: GoogleFonts.cinzel(
                color: AppColors.goldBright,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${currentCase.category} • Dificuldade: ${currentCase.difficulty}',
              style: GoogleFonts.montserrat(
                color: AppColors.textMuted,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.wineCrimson,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.goldBorder.withValues(alpha: 0.6)),
                ),
                child: Text(
                  '+${currentCase.rewardPoints} PTS',
                  style: GoogleFonts.cinzel(
                    color: AppColors.goldBright,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ABA 1: BARALHO DE CARTAS CENTRALIZADO
          _buildCardsDeckTab(currentCase, service),

          // ABA 2: DESAFIOS FORENSES JOGÁVEIS DIRETAMENTE NO SITE
          _buildInAppMissionsTab(currentCase, service),

          // ABA 3: MESA DE ACUSAÇÃO COM AS 4 CARTAS
          _buildAccusationTableTab(currentCase, service),
        ],
      ),
    );
  }

  // ========================================================
  // ABA 1: BARALHO DE CARTAS (CENTRALIZADO & 4 CATEGORIAS)
  // ========================================================
  Widget _buildCardsDeckTab(CriminalCaseModel currentCase, SupabaseService service) {
    final suspects = currentCase.cards.where((c) => c.type == CardType.suspect).toList();
    final weapons = currentCase.cards.where((c) => c.type == CardType.weapon).toList();
    final locations = currentCase.cards.where((c) => c.type == CardType.location).toList();
    final evidences = currentCase.cards.where((c) => c.type == CardType.evidence).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1050),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner da Investigação em Vinho e Preto
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.wineCrimson, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.biotech, color: AppColors.wineBright, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'RELATÓRIO DO LOCAL DO HOMICÍDIO',
                          style: GoogleFonts.cinzel(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.wineBright,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentCase.synopsis,
                      style: GoogleFonts.merriweather(
                        fontSize: 13,
                        color: AppColors.textLight,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 14, color: AppColors.goldBright),
                        const SizedBox(width: 4),
                        Text(
                          'Vítima: ${currentCase.victim}',
                          style: GoogleFonts.montserrat(fontSize: 11, color: AppColors.textGold),
                        ),
                        const SizedBox(width: 14),
                        const Icon(Icons.access_time, size: 14, color: AppColors.goldBright),
                        const SizedBox(width: 4),
                        Text(
                          currentCase.timeOfCrime,
                          style: GoogleFonts.montserrat(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 1. Acusados
              _buildCenteredCategorySection(
                title: '1. ACUSADOS (SUSPEITOS)',
                subtitle: 'Apenas um orquestrou o assassinato. Os outros possuem álibis ou foram manipulados.',
                cards: suspects,
                selectedId: _selectedSuspectId,
                service: service,
                currentCase: currentCase,
                onSelect: (id) => setState(() => _selectedSuspectId = id),
              ),
              const SizedBox(height: 28),

              // 2. Armas / Métodos
              _buildCenteredCategorySection(
                title: '2. ARMAS & MÉTODOS LETAIS',
                subtitle: 'Cuidado com pistas falsas deixadas no local para simular causas naturais.',
                cards: weapons,
                selectedId: _selectedWeaponId,
                service: service,
                currentCase: currentCase,
                onSelect: (id) => setState(() => _selectedWeaponId = id),
              ),
              const SizedBox(height: 28),

              // 3. Locais da Cena
              _buildCenteredCategorySection(
                title: '3. LOCAIS DA CENA DO CRIME',
                subtitle: 'Onde o ataque letal ocorreu de verdade antes do corpo ser transportado.',
                cards: locations,
                selectedId: _selectedLocationId,
                service: service,
                currentCase: currentCase,
                onSelect: (id) => setState(() => _selectedLocationId = id),
              ),
              const SizedBox(height: 28),

              // 4. Vestígios Forenses
              _buildCenteredCategorySection(
                title: '4. VESTÍGIOS FORENSES & PROVAS',
                subtitle: 'A prova física irrefutável que conecta o assassino ao local do ataque.',
                cards: evidences,
                selectedId: _selectedEvidenceId,
                service: service,
                currentCase: currentCase,
                onSelect: (id) => setState(() => _selectedEvidenceId = id),
              ),
              const SizedBox(height: 36),

              // Botão para ir à Acusação
              Center(
                child: SizedBox(
                  width: 420,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.wineCrimson,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: AppColors.goldBright, width: 1.5),
                      ),
                      elevation: 8,
                    ),
                    onPressed: () => _tabController.animateTo(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.gavel, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'IR PARA A MESA DE ACUSAÇÃO',
                          style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenteredCategorySection({
    required String title,
    required String subtitle,
    required List<CrimeCard> cards,
    required String? selectedId,
    required SupabaseService service,
    required CriminalCaseModel currentCase,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.goldBright,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(fontSize: 11, color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: cards.map((card) {
              final isUnlocked = service.isCardUnlocked(card.id);
              final isSelected = selectedId == card.id;

              return CrimeCardItemWidget(
                card: card,
                isUnlocked: isUnlocked,
                isSelected: isSelected,
                onSelect: () => onSelect(card.id),
                onUnlockRequest: () => _openMissionDialogForCard(context, card, currentCase, service),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ========================================================
  // ABA 2: DESAFIOS FORENSES (COM PROVAS EXPLÍCITAS & CLARAS)
  // ========================================================
  Widget _buildInAppMissionsTab(CriminalCaseModel currentCase, SupabaseService service) {
    final missions = currentCase.inAppMissions;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850),
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: missions.length,
          itemBuilder: (context, index) {
            final mission = missions[index];
            final isDone = mission.isCompleted;
            final selectedOption = _selectedOptions[mission.id];
            final feedback = _missionFeedbacks[mission.id];

            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDone ? const Color(0xFF10B981) : AppColors.wineCrimson,
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho da Missão
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDone ? const Color(0xFF064E3B) : AppColors.surfaceElevated,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDone ? const Color(0xFF10B981) : AppColors.goldBorder,
                          ),
                        ),
                        child: Icon(
                          isDone ? Icons.check : Icons.menu_book,
                          color: isDone ? const Color(0xFF34D399) : AppColors.goldBright,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DESAFIO FORENSE #${index + 1}',
                              style: GoogleFonts.cinzel(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: isDone ? const Color(0xFF34D399) : AppColors.goldBorder,
                                letterSpacing: 1.1,
                              ),
                            ),
                            Text(
                              mission.title,
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.goldBorder.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          '+${mission.points} PTS',
                          style: GoogleFonts.cinzel(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldBright,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 1. O DOCUMENTO PERICIAL EM DESTAQUE (A PROVA PARA LER)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0407),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.wineBright.withValues(alpha: 0.6), width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description, size: 16, color: AppColors.goldBright),
                            const SizedBox(width: 8),
                            Text(
                              'EVIDÊNCIA COLETADA • LAUDO PERICIAL OFICIAL',
                              style: GoogleFonts.cinzel(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldBright,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Color(0xFF3B101E), height: 18),
                        Text(
                          mission.forensicClueDocument,
                          style: GoogleFonts.merriweather(
                            fontSize: 12.5,
                            color: const Color(0xFFFDE8EF),
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. A PERGUNTA DE DEDUÇÃO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.help_outline, size: 18, color: AppColors.goldBright),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            mission.challengeQuestion,
                            style: GoogleFonts.cinzel(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. OPÇÕES DE RESPOSTA FORMATADAS (A, B, C, D)
                  if (!isDone) ...[
                    Text(
                      'Com base no laudo oficial acima, selecione a dedução correta:',
                      style: GoogleFonts.montserrat(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ...List.generate(mission.options.length, (optIdx) {
                      final optionText = mission.options[optIdx];
                      final isSelected = selectedOption == optIdx;
                      final optionLetter = String.fromCharCode(65 + optIdx); // A, B, C, D

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedOptions[mission.id] = optIdx;
                              _missionFeedbacks[mission.id] = null;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF2E0916) : AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? AppColors.goldBright : AppColors.surfaceBorder,
                                width: isSelected ? 1.8 : 1.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.goldBright.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.goldDark : AppColors.surfaceElevated,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AppColors.goldBright : AppColors.surfaceBorder,
                                    ),
                                  ),
                                  child: Text(
                                    optionLetter,
                                    style: GoogleFonts.cinzel(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : AppColors.textMuted,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12.5,
                                      color: isSelected ? Colors.white : AppColors.textLight,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Feedback de Erro
                    if (feedback != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF450A1A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFEF4444)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, size: 18, color: Color(0xFFF87171)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feedback,
                                style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Botão Submeter Análise
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedOption != null ? AppColors.wineCrimson : AppColors.surfaceElevated,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: selectedOption != null ? AppColors.goldBright : AppColors.surfaceBorder,
                              width: 1.2,
                            ),
                          ),
                        ),
                        onPressed: selectedOption == null
                            ? null
                            : () => _handleAnswerMission(service, currentCase, mission, selectedOption),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'SUBMETER ANÁLISE FORENSE & DESTRAVAR CARTAS',
                              style: GoogleFonts.cinzel(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Estado Concluído
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF064E3B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF10B981)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.verified, color: Color(0xFF34D399), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'ANÁLISE VALIDADA PELA AGÊNCIA',
                                style: GoogleFonts.cinzel(
                                  color: const Color(0xFFD1FAE5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            mission.explanation,
                            style: GoogleFonts.merriweather(
                              color: const Color(0xFFD1FAE5),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Cartas liberadas: ${mission.unlockedCardTitle} (já disponíveis no Baralho!)',
                            style: GoogleFonts.montserrat(
                              color: AppColors.goldBright,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ========================================================
  // ABA 3: MESA DE ACUSAÇÃO (4 CARTAS DE DEDUÇÃO FORENSE)
  // ========================================================
  Widget _buildAccusationTableTab(CriminalCaseModel currentCase, SupabaseService service) {
    CrimeCard? suspectCard = _getCardById(currentCase, _selectedSuspectId);
    CrimeCard? weaponCard = _getCardById(currentCase, _selectedWeaponId);
    CrimeCard? locationCard = _getCardById(currentCase, _selectedLocationId);
    CrimeCard? evidenceCard = _getCardById(currentCase, _selectedEvidenceId);

    final bool allCardsSelected =
        suspectCard != null && weaponCard != null && locationCard != null && evidenceCard != null;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'FORMULAÇÃO DA ACUSAÇÃO FORENSE',
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldBright,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Para solucionar o caso, você precisa apresentar o quarteto forense completo sem contradições.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 24),

              // Os 4 Slots de Acusação
              _buildAccusationSlot(
                slotTitle: '1. O ACUSADO CULPADO',
                card: suspectCard,
                placeholderText: 'Toque para escolher o acusado no baralho',
                color: AppColors.typeSuspect,
                onRemove: () => setState(() => _selectedSuspectId = null),
              ),
              const SizedBox(height: 12),

              _buildAccusationSlot(
                slotTitle: '2. A ARMA / MÉTODO REAL DO CRIME',
                card: weaponCard,
                placeholderText: 'Toque para escolher a arma no baralho',
                color: AppColors.typeWeapon,
                onRemove: () => setState(() => _selectedWeaponId = null),
              ),
              const SizedBox(height: 12),

              _buildAccusationSlot(
                slotTitle: '3. O LOCAL REAL DA EXECUÇÃO',
                card: locationCard,
                placeholderText: 'Toque para escolher o local no baralho',
                color: AppColors.typeLocation,
                onRemove: () => setState(() => _selectedLocationId = null),
              ),
              const SizedBox(height: 12),

              _buildAccusationSlot(
                slotTitle: '4. O VESTÍGIO FORENSE DECISIVO',
                card: evidenceCard,
                placeholderText: 'Toque para escolher o vestígio no baralho',
                color: AppColors.typeEvidence,
                onRemove: () => setState(() => _selectedEvidenceId = null),
              ),
              const SizedBox(height: 24),

              // Feedback de Acusação
              if (_accusationFeedback != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isAccusationSuccess
                        ? const Color(0xFF064E3B)
                        : const Color(0xFF450A1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isAccusationSuccess
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isAccusationSuccess ? Icons.stars : Icons.error_outline,
                            color: _isAccusationSuccess
                                ? const Color(0xFF34D399)
                                : const Color(0xFFF87171),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isAccusationSuccess ? 'CRIME DESVENDADO!' : 'DEDUÇÃO REJEITADA',
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _accusationFeedback!,
                        style: GoogleFonts.merriweather(
                          fontSize: 12.5,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      if (_resolutionStory != null) ...[
                        const Divider(color: Color(0xFF34D399), height: 24),
                        Text(
                          _resolutionStory!,
                          style: GoogleFonts.merriweather(
                            fontSize: 13,
                            color: const Color(0xFFD1FAE5),
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Botão Desvendar o Crime
              if (!_isAccusationSuccess)
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: allCardsSelected
                          ? AppColors.wineCrimson
                          : AppColors.surfaceElevated,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: allCardsSelected ? AppColors.goldBright : AppColors.surfaceBorder,
                          width: 1.5,
                        ),
                      ),
                      elevation: allCardsSelected ? 8 : 0,
                    ),
                    onPressed: allCardsSelected
                        ? () => _handleSolveCrime(service, currentCase)
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.fingerprint, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          allCardsSelected
                              ? 'DESVENDAR CRIME COM AS 4 CARTAS'
                              : 'SELECIONE AS 4 CARTAS NO BARALHO',
                          style: GoogleFonts.cinzel(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CASO CONCLUÍDO • RETORNAR AO MAPA',
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccusationSlot({
    required String slotTitle,
    required CrimeCard? card,
    required String placeholderText,
    required Color color,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: card != null ? color : AppColors.surfaceBorder,
          width: card != null ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slotTitle,
            style: GoogleFonts.cinzel(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          if (card != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color),
                  ),
                  child: Icon(card.icon, size: 24, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        card.subtitle,
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: AppColors.goldBright,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                  onPressed: onRemove,
                ),
              ],
            )
          else
            InkWell(
              onTap: () => _tabController.animateTo(0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle_outline, size: 20, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    Text(
                      placeholderText,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  CrimeCard? _getCardById(CriminalCaseModel currentCase, String? id) {
    if (id == null) return null;
    try {
      return currentCase.cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void _openMissionDialogForCard(
    BuildContext context,
    CrimeCard card,
    CriminalCaseModel currentCase,
    SupabaseService service,
  ) {
    _tabController.animateTo(1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.wineCrimson,
        content: Text(
          'Leia o laudo pericial na aba de desafios e responda para destravar a carta "${card.title}"!',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      ),
    );
  }

  void _handleAnswerMission(
    SupabaseService service,
    CriminalCaseModel currentCase,
    InAppMission mission,
    int selectedOption,
  ) async {
    if (selectedOption == mission.correctOptionIndex) {
      await service.completeInAppMission(currentCase, mission);
      setState(() {
        _missionFeedbacks[mission.id] = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF064E3B),
            content: Text(
              'Dedução pericial correta! ${mission.unlockedCardTitle} foram liberadas no baralho!',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _missionFeedbacks[mission.id] =
            'Conclusão incorreta. Releia o Laudo Pericial oficial no box acima para encontrar os detalhes decisivos!';
      });
    }
  }

  void _handleSolveCrime(SupabaseService service, CriminalCaseModel currentCase) {
    final result = service.verifyDeduction(
      caseData: currentCase,
      suspectCardId: _selectedSuspectId!,
      weaponCardId: _selectedWeaponId!,
      locationCardId: _selectedLocationId!,
      evidenceCardId: _selectedEvidenceId!,
    );

    setState(() {
      _isAccusationSuccess = result['success'] == true;
      if (_isAccusationSuccess) {
        _accusationFeedback = result['message'];
        _resolutionStory = result['story'];
      } else {
        _accusationFeedback = result['hint'];
        _resolutionStory = null;
      }
    });
  }
}
