import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/deduction_card_model.dart';
import '../core/constants/app_colors.dart';

class InvestigationCardWidget extends StatefulWidget {
  final DeductionCard card;
  final bool isSelected;
  final VoidCallback onSelect;

  const InvestigationCardWidget({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<InvestigationCardWidget> createState() => _InvestigationCardWidgetState();
}

class _InvestigationCardWidgetState extends State<InvestigationCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_showBack) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _showBack = !_showBack);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;
        final isUnder = angle > (pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015) // Perspectiva 3D
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isUnder
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi), // Desinverte o texto no verso
                  alignment: Alignment.center,
                  child: _buildBackFace(),
                )
              : _buildFrontFace(),
        );
      },
    );
  }

  // Frente da Carta de Evidência
  Widget _buildFrontFace() {
    return GestureDetector(
      onTap: widget.onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 175,
        height: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardFrontBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isSelected ? AppColors.goldBright : AppColors.cardBorder.withValues(alpha: 0.5),
            width: widget.isSelected ? 2.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isSelected
                  ? AppColors.goldBright.withValues(alpha: 0.35)
                  : Colors.black.withValues(alpha: 0.5),
              blurRadius: widget.isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tag da Carta (Cabeçalho)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F141D),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.goldBorder.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    widget.card.typeTag,
                    style: GoogleFonts.cinzel(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldBright,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                InkWell(
                  onTap: _flipCard,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF263345),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.flip, size: 14, color: AppColors.goldBright),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Ícone da Evidência
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F141D),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected ? AppColors.goldBright : const Color(0xFF2A374A),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  widget.card.icon,
                  size: 32,
                  color: widget.isSelected ? AppColors.goldBright : AppColors.textGold,
                ),
              ),
            ),
            const Spacer(),

            // Título
            Text(
              widget.card.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cinzel(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            // Breve Descrição
            Text(
              widget.card.frontDescription,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: AppColors.textMuted,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),

            // Indicador de Seleção
            Container(
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.isSelected ? AppColors.goldBorder : const Color(0xFF0F141D),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.isSelected ? 'SELECIONADA' : 'TOCAR PARA ESCOLHER',
                style: GoogleFonts.cinzel(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected ? Colors.white : AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Verso da Carta de Evidência (Anotações Secretas do Perito)
  Widget _buildBackFace() {
    return Container(
      width: 175,
      height: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131822),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldBright, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
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
                onTap: _flipCard,
                child: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
              ),
            ],
          ),
          const Divider(color: Color(0xFF283445), height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.card.backSecretNotes,
                style: GoogleFonts.courierPrime(
                  fontSize: 11,
                  color: const Color(0xFFF1F5F9),
                  height: 1.45,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldDark,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              minimumSize: const Size(double.infinity, 26),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              _flipCard();
              widget.onSelect();
            },
            child: Text(
              'USAR CARTA',
              style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
