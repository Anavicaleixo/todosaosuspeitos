import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../core/constants/app_colors.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<SupabaseService>();
    final currentProfile = service.profile;

    final agents = [
      {'rank': 1, 'name': 'Agente Blackwood', 'title': 'Inspetor-Chefe', 'score': 850, 'streak': 14},
      {'rank': 2, 'name': 'Agente Sterling', 'title': 'Detetive Sênior', 'score': 620, 'streak': 9},
      {'rank': 3, 'name': currentProfile.fullName, 'title': currentProfile.badgeTitle, 'score': currentProfile.totalScore, 'streak': currentProfile.streakDays, 'isUser': true},
      {'rank': 4, 'name': 'Agente Moreau', 'title': 'Investigador', 'score': 90, 'streak': 2},
      {'rank': 5, 'name': 'Agente Holloway', 'title': 'Detetive Novato', 'score': 50, 'streak': 1},
    ];

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
          'QUADRO DE HONRA DA AGÊNCIA',
          style: GoogleFonts.cinzel(color: AppColors.goldBright, letterSpacing: 1.2),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: agents.length,
        itemBuilder: (context, index) {
          final agent = agents[index];
          final isUser = agent['isUser'] == true;
          final rank = agent['rank'] as int;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF231C0F) : AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUser ? AppColors.goldBright : AppColors.surfaceBorder,
                width: isUser ? 2 : 1,
              ),
              boxShadow: isUser
                  ? [
                      BoxShadow(
                        color: AppColors.goldBright.withValues(alpha: 0.15),
                        blurRadius: 10,
                      )
                    ]
                  : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    '#$rank',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: rank == 1
                          ? const Color(0xFFFFD700)
                          : rank == 2
                              ? const Color(0xFFC0C0C0)
                              : rank == 3
                                  ? const Color(0xFFCD7F32)
                                  : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            agent['name'] as String,
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isUser ? AppColors.goldBright : Colors.white,
                            ),
                          ),
                          if (isUser) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.goldDark,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'VOCÊ',
                                style: GoogleFonts.cinzel(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        agent['title'] as String,
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${agent['score']} pts',
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldBright,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, size: 12, color: Color(0xFFFF9100)),
                        const SizedBox(width: 2),
                        Text(
                          '${agent['streak']} dias',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            color: const Color(0xFFFFB74D),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
