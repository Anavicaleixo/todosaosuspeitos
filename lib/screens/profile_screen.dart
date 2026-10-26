import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<SupabaseService>();
    final profile = service.profile;
    final cases = service.criminalCases;
    final solvedCount = cases.where((c) => c.status.name == 'completed').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.goldBright),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.surfaceBorder, height: 1.0),
        ),
        title: Text(
          'DOSSIÊ DO DETETIVE',
          style: GoogleFonts.cinzel(color: AppColors.goldBright, letterSpacing: 1.2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Crachá Oficial da Agência
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.goldBorder, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.surfaceElevated,
                    child: const Icon(Icons.security, size: 45, color: AppColors.goldBright),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    profile.fullName.toUpperCase(),
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldBright,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.badgeTitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(color: AppColors.surfaceBorder, height: 32),

                  // Estatísticas do Jogador
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('NÍVEL', '${profile.detectiveLevel}', Icons.military_tech),
                      _buildStatItem('PONTUAÇÃO', '${profile.totalScore}', Icons.stars),
                      _buildStatItem('STREAK', '${profile.streakDays} dias', Icons.local_fire_department),
                      _buildStatItem('RESOLVIDOS', '$solvedCount', Icons.folder_special),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Conquistas por Categoria
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CONQUISTAS DE INVESTIGAÇÃO',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldBright,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildAchievementTile(
              title: 'Primeira Dedução',
              description: 'Resolva o seu primeiro caso na teia da agência.',
              icon: Icons.lightbulb,
              unlocked: solvedCount >= 1,
            ),
            _buildAchievementTile(
              title: 'Mestre da Vigilância',
              description: 'Complete missões de observação e foco.',
              icon: Icons.remove_red_eye,
              unlocked: solvedCount >= 2,
            ),
            _buildAchievementTile(
              title: 'Especialista em Cartas Forenses',
              description: 'Acerte deduções usando o baralho de evidências.',
              icon: Icons.style,
              unlocked: solvedCount >= 3,
            ),
            _buildAchievementTile(
              title: 'Hábito Inquebrável',
              description: 'Mantenha um streak consecutivo de 5 dias de hábitos.',
              icon: Icons.whatshot,
              unlocked: profile.streakDays >= 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.goldBright, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.cinzel(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementTile({
    required String title,
    required String description,
    required IconData icon,
    required bool unlocked,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: unlocked ? AppColors.goldBorder : AppColors.surfaceBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: unlocked ? const Color(0xFF2C220E) : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: unlocked ? AppColors.goldBright : AppColors.textMuted,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: unlocked ? AppColors.goldBright : AppColors.textMuted,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle, color: Color(0xFFA855F7), size: 20),
        ],
      ),
    );
  }
}
