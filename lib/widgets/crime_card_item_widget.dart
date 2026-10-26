import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/crime_card_model.dart';
import '../core/constants/app_colors.dart';

class CrimeCardItemWidget extends StatefulWidget {
  final CrimeCard card;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onUnlockRequest;

  const CrimeCardItemWidget({
    super.key,
    required this.card,
    required this.isUnlocked,
    required this.isSelected,
    required this.onSelect,
    required this.onUnlockRequest,
  });

  @override
  State<CrimeCardItemWidget> createState() => _CrimeCardItemWidgetState();
}

class _CrimeCardItemWidgetState extends State<CrimeCardItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (!widget.isUnlocked) return;
    if (_showBack) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _showBack = !_showBack);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isUnlocked) {
      return _buildLockedBackFace();
    }

    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;
        final isUnder = angle > (pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isUnder
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: _buildBackFace(),
                )
              : _buildFrontFace(),
        );
      },
    );
  }

  // Carta Lacrada (Estilo Vinho e Preto Gótico)
  Widget _buildLockedBackFace() {
    return GestureDetector(
      onTap: widget.onUnlockRequest,
      child: Container(
        width: 175,
        height: 260,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.wineBright.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.lock, size: 28, color: AppColors.wineBright),
            ),
            const SizedBox(height: 12),
            Text(
              'CARTA LACRADA',
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Toque para resolver o enigma forense no site e liberar.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: AppColors.textMuted,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.wineCrimson,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.wineBright),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.psychology, size: 12, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    'RESOLVER DESAFIO',
                    style: GoogleFonts.cinzel(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Frente da Carta Desbloqueada (Vinho & Ouro)
  Widget _buildFrontFace() {
    final cardColor = widget.card.typeColor;

    return GestureDetector(
      onTap: widget.onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 175,
        height: 260,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardFrontBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isSelected ? AppColors.goldBright : cardColor.withValues(alpha: 0.7),
            width: widget.isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isSelected
                  ? AppColors.goldBright.withValues(alpha: 0.4)
                  : AppColors.wineGlow,
              blurRadius: widget.isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho da Carta com Categoria
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: cardColor),
                  ),
                  child: Text(
                    widget.card.typeLabel,
                    style: GoogleFonts.cinzel(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                InkWell(
                  onTap: _flip,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.flip, size: 13, color: AppColors.goldBright),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Ícone da Evidência
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: cardColor.withValues(alpha: 0.5), width: 1.5),
                ),
                child: Icon(widget.card.icon, size: 30, color: cardColor),
              ),
            ),
            const Spacer(),

            // Título
            Text(
              widget.card.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cinzel(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              widget.card.subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 9.5,
                color: AppColors.goldBright,
              ),
            ),
            const SizedBox(height: 6),

            // Breve Descrição
            Text(
              widget.card.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 9.5,
                color: AppColors.textLight.withValues(alpha: 0.8),
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),

            // Botão Selecionar
            Container(
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.isSelected ? AppColors.goldDark : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: widget.isSelected ? AppColors.goldBright : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isSelected) ...[
                    const Icon(Icons.check, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    widget.isSelected ? 'SELECIONADA' : 'USAR NA ACUSAÇÃO',
                    style: GoogleFonts.cinzel(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Verso da Carta: Laudo Pericial Detalhado
  Widget _buildBackFace() {
    return Container(
      width: 175,
      height: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldBright, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LAUDO DO PERITO',
                style: GoogleFonts.cinzel(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldBright,
                  letterSpacing: 1.2,
                ),
              ),
              InkWell(
                onTap: _flip,
                child: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
              ),
            ],
          ),
          const Divider(color: AppColors.surfaceBorder, height: 14),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.card.secretClue,
                style: GoogleFonts.courierPrime(
                  fontSize: 10.5,
                  color: AppColors.textLight,
                  height: 1.45,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.wineCrimson,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              minimumSize: const Size(double.infinity, 26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: AppColors.wineBright),
              ),
            ),
            onPressed: () {
              _flip();
              widget.onSelect();
            },
            child: Text(
              'ESCOLHER CARTA',
              style: GoogleFonts.cinzel(fontSize: 9.5, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
