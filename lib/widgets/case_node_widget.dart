import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/criminal_case_model.dart';
import '../models/case_model.dart';
import '../core/constants/app_colors.dart';

class CaseNodeWidget extends StatefulWidget {
  final CriminalCaseModel caseData;
  final VoidCallback onTap;

  const CaseNodeWidget({
    super.key,
    required this.caseData,
    required this.onTap,
  });

  @override
  State<CaseNodeWidget> createState() => _CaseNodeWidgetState();
}

class _CaseNodeWidgetState extends State<CaseNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.caseData.status;
    final isCenter = widget.caseData.isRoot;
    final double nodeSize = isCenter ? 48.0 : 38.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: status == CaseStatus.locked
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Tag "Novo!" idêntica à do Fireboy & Watergirl
            if (status == CaseStatus.unlocked && !isCenter)
              Positioned(
                top: -18,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    );
                  },
                  child: Text(
                    'Novo!',
                    style: GoogleFonts.cinzel(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldBright,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // O Nó Facetado
            AnimatedScale(
              scale: _isHovered && status != CaseStatus.locked ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutQuad,
              child: CustomPaint(
                size: Size(nodeSize, nodeSize),
                painter: _FacetedGemPainter(
                  status: status,
                  isCenter: isCenter,
                  isHovered: _isHovered,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FacetedGemPainter extends CustomPainter {
  final CaseStatus status;
  final bool isCenter;
  final bool isHovered;

  _FacetedGemPainter({
    required this.status,
    required this.isCenter,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    late Color outerBezel;
    late Color innerBezel;
    late Color gemTop;
    late Color gemBottom;
    late Color gemCenter;

    switch (status) {
      case CaseStatus.completed:
        outerBezel = AppColors.trackGoldOuter;
        innerBezel = AppColors.goldBright;
        gemTop = const Color(0xFFD8B4FE);
        gemCenter = AppColors.nodeCompletedGem;
        gemBottom = const Color(0xFF6B21A8);
        break;

      case CaseStatus.unlocked:
        outerBezel = AppColors.trackGoldOuter;
        innerBezel = AppColors.goldBright;
        gemTop = const Color(0xFFFED7AA);
        gemCenter = AppColors.nodeAvailableGem;
        gemBottom = const Color(0xFFC2410C);
        break;

      case CaseStatus.locked:
        outerBezel = AppColors.nodeLockedBorder;
        innerBezel = const Color(0xFF334155);
        gemTop = const Color(0xFF475569);
        gemCenter = AppColors.nodeLockedGem;
        gemBottom = const Color(0xFF0F172A);
        break;
    }

    if (isHovered && status != CaseStatus.locked) {
      final glowPaint = Paint()
        ..color = innerBezel.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(center, radius + 4, glowPaint);
    }

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center + const Offset(0, 3), radius, shadowPaint);

    final outerPath = _createHexagonPath(center, radius);
    final outerPaint = Paint()
      ..color = outerBezel
      ..style = PaintingStyle.fill;
    canvas.drawPath(outerPath, outerPaint);

    final innerBezelPath = _createHexagonPath(center, radius * 0.85);
    final innerBezelPaint = Paint()
      ..color = innerBezel
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerBezelPath, innerBezelPaint);

    final gemBorderPath = _createHexagonPath(center, radius * 0.72);
    final gemBorderPaint = Paint()
      ..color = const Color(0xFF080B0F)
      ..style = PaintingStyle.fill;
    canvas.drawPath(gemBorderPath, gemBorderPaint);

    final gemPath = _createHexagonPath(center, radius * 0.65);
    final gemGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [gemTop, gemCenter, gemBottom],
    );
    final gemPaint = Paint()
      ..shader = gemGradient.createShader(Rect.fromCircle(center: center, radius: radius * 0.65))
      ..style = PaintingStyle.fill;
    canvas.drawPath(gemPath, gemPaint);

    final highlightPath = Path()
      ..moveTo(center.dx, center.dy - radius * 0.65)
      ..lineTo(center.dx + radius * 0.45, center.dy - radius * 0.25)
      ..lineTo(center.dx, center.dy)
      ..lineTo(center.dx - radius * 0.45, center.dy - radius * 0.25)
      ..close();

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: status == CaseStatus.locked ? 0.15 : 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawPath(highlightPath, highlightPaint);

    if (status == CaseStatus.locked) {
      final lockPaint = Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(Offset(center.dx, center.dy - 2), 2.5, lockPaint);
      final bodyPaint = Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy + 3), width: 6, height: 5), bodyPaint);
    }
  }

  Path _createHexagonPath(Offset center, double radius) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius * 0.85, center.dy - radius * 0.45);
    path.lineTo(center.dx + radius * 0.85, center.dy + radius * 0.45);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius * 0.85, center.dy + radius * 0.45);
    path.lineTo(center.dx - radius * 0.85, center.dy - radius * 0.45);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _FacetedGemPainter oldDelegate) {
    return oldDelegate.status != status ||
        oldDelegate.isCenter != isCenter ||
        oldDelegate.isHovered != isHovered;
  }
}
