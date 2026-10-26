import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../models/criminal_case_model.dart';
import '../models/case_model.dart';
import '../data/criminal_cases_data.dart';
import '../core/constants/app_colors.dart';
import '../widgets/case_connection_painter.dart';
import '../widgets/case_node_widget.dart';
import '../widgets/case_dossier_modal.dart';
import 'crime_investigation_screen.dart';
import 'profile_screen.dart';
import 'ranking_screen.dart';
import 'auth_screen.dart';

class CaseMapScreen extends StatefulWidget {
  const CaseMapScreen({super.key});

  @override
  State<CaseMapScreen> createState() => _CaseMapScreenState();
}

class _CaseMapScreenState extends State<CaseMapScreen> {
  final TransformationController _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    final service = context.watch<SupabaseService>();
    final cases = service.criminalCases.isNotEmpty
        ? service.criminalCases
        : CriminalCasesData.getInitialCases();
    final profile = service.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Fundo Nobre: Azul-Noturno e Grafite Profundo
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.15,
                  colors: [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientCenter,
                    AppColors.backgroundGradientEnd,
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // Grade sutil de fundo estilo blueprint forense
          Positioned.fill(
            child: CustomPaint(
              painter: _SubtleGridPainter(),
            ),
          ),

          // 2. A Teia Radial Interativa (com suporte a Pan & Zoom)
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(600),
              minScale: 0.55,
              maxScale: 2.5,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

                  return Stack(
                    children: [
                      // Pintor das Linhas Douradas Conectoras
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: CaseConnectionPainter(
                          cases: cases,
                          centerOffset: center,
                        ),
                      ),

                      // Nós dos Casos Posicionados na Teia
                      ...cases.map((c) {
                        final nodeSize = c.isRoot ? 48.0 : 38.0;
                        final left = center.dx + c.mapX - (nodeSize / 2);
                        final top = center.dy + c.mapY - (nodeSize / 2);

                        return Positioned(
                          left: left,
                          top: top,
                          child: CaseNodeWidget(
                            caseData: c,
                            onTap: () => _handleNodeTap(context, c),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),

          // 3. Botão "Voltar" idêntico à imagem de referência (canto inferior esquerdo)
          Positioned(
            left: 28,
            bottom: 28,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _transformationController.value = Matrix4.identity();
                },
                child: Row(
                  children: [
                    CustomPaint(
                      size: const Size(32, 44),
                      painter: _GoldenChevronPainter(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Voltar',
                      style: GoogleFonts.cinzel(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.goldBright,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 6,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Rodapé Informativo (canto inferior direito)
          Positioned(
            right: 28,
            bottom: 28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Text(
                'ARQUIVO DE HOMICÍDIOS • REDE DE CASOS CRIMINAIS',
                style: GoogleFonts.cinzel(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.goldBright,
                ),
              ),
            ),
          ),

          // 5. Barra Superior de Controle do Detetive (HUD)
          Positioned(
            top: 16,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Crachá do Detetive
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.goldBorder, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield, color: AppColors.goldBright, size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              profile.fullName.toUpperCase(),
                              style: GoogleFonts.cinzel(
                                color: AppColors.goldBright,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${profile.badgeTitle} • ${profile.totalScore} pts',
                              style: GoogleFonts.montserrat(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Streak de Hábito & Atalhos
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF97316), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Color(0xFFFB923C), size: 18),
                          const SizedBox(width: 5),
                          Text(
                            '${profile.streakDays} DIAS',
                            style: GoogleFonts.cinzel(
                              color: const Color(0xFFFED7AA),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    _buildIconButton(
                      icon: Icons.leaderboard,
                      tooltip: 'Ranking da Agência',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RankingScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),

                    _buildIconButton(
                      icon: service.isAuthenticated ? Icons.logout : Icons.person_outline,
                      tooltip: service.isAuthenticated ? 'Sair' : 'Acessar Conta',
                      onTap: () {
                        if (service.isAuthenticated) {
                          service.signOut();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AuthScreen()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNodeTap(BuildContext context, CriminalCaseModel caseData) {
    if (caseData.status == CaseStatus.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.surfaceBorder),
          ),
          content: Row(
            children: [
              const Icon(Icons.lock, color: AppColors.textMuted, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Arquivo criminal bloqueado. Solucione os homicídios anteriores para destravar novas evidências.',
                  style: GoogleFonts.montserrat(color: AppColors.textLight, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => CaseDossierModal(
        caseData: caseData,
        onStartInvestigation: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CrimeInvestigationScreen(caseData: caseData),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.goldBorder, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.goldBright, size: 18),
        tooltip: tooltip,
        onPressed: onTap,
        splashRadius: 20,
      ),
    );
  }
}

class _SubtleGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2638).withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoldenChevronPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width * 0.4, 0);
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width * 0.4, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.5, size.height / 2);
    path.close();

    final borderPaint = Paint()
      ..color = const Color(0xFF080B0F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawPath(path, borderPaint);

    final goldPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFD166), Color(0xFFB45309)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
