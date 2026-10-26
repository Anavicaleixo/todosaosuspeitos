import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/criminal_case_model.dart';
import '../models/case_model.dart';
import '../core/constants/app_colors.dart';

class CaseDossierModal extends StatelessWidget {
  final CriminalCaseModel caseData;
  final VoidCallback onStartInvestigation;

  const CaseDossierModal({
    super.key,
    required this.caseData,
    required this.onStartInvestigation,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = caseData.status == CaseStatus.completed;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.goldBorder, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 25,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: AppColors.goldBright.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabeçalho da Pasta Criminal
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  border: Border(
                    bottom: BorderSide(color: AppColors.surfaceBorder, width: 1.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? const Color(0xFF581C87)
                                : const Color(0xFF7C2D12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isCompleted
                                  ? const Color(0xFFA855F7)
                                  : const Color(0xFFEA580C),
                            ),
                          ),
                          child: Text(
                            isCompleted ? 'CRIME RESOLVIDO' : 'CASO HOMICÍDIO',
                            style: GoogleFonts.cinzel(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ID: ${caseData.id.toUpperCase()}',
                          style: GoogleFonts.courierPrime(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),

              // Conteúdo do Dossiê
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caseData.title,
                      style: GoogleFonts.cinzel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldBright,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Badges (Wrap para evitar qualquer overflow)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildTag(Icons.category, caseData.category),
                        _buildTag(Icons.speed, caseData.difficulty),
                        _buildTag(Icons.star, '+${caseData.rewardPoints} pts'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Relatório da Cena
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, size: 15, color: Color(0xFFEF4444)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'VÍTICA: ${caseData.victim}',
                                  style: GoogleFonts.cinzel(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.place, size: 15, color: AppColors.goldBright),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'CENA: ${caseData.crimeScene}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.surfaceBorder, height: 16),
                          Text(
                            caseData.synopsis,
                            style: GoogleFonts.merriweather(
                              fontSize: 12.5,
                              color: AppColors.textLight,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Informações do Baralho de Cartas do Caso
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildCardStat(Icons.person, '4 Suspeitos', AppColors.typeSuspect),
                          _buildCardStat(Icons.science, '3 Armas', AppColors.typeWeapon),
                          _buildCardStat(Icons.place, '3 Locais', AppColors.typeLocation),
                          _buildCardStat(Icons.fingerprint, '3 Vestígios', AppColors.typeEvidence),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Botão Iniciar Investigação
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCompleted
                              ? const Color(0xFF6B21A8)
                              : AppColors.goldDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isCompleted
                                  ? const Color(0xFFA855F7)
                                  : AppColors.goldBright,
                              width: 1.5,
                            ),
                          ),
                          elevation: 6,
                        ),
                        onPressed: onStartInvestigation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.style, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isCompleted
                                  ? 'REVER BARALHO & PROVAS'
                                  : 'ABRIR MESA DE INVESTIGAÇÃO & CARTAS',
                              style: GoogleFonts.cinzel(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardStat(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.cinzel(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.goldBright),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
