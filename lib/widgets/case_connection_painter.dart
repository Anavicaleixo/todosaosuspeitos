import 'package:flutter/material.dart';
import '../models/criminal_case_model.dart';
import '../models/case_model.dart';
import '../core/constants/app_colors.dart';

class CaseConnectionPainter extends CustomPainter {
  final List<CriminalCaseModel> cases;
  final Offset centerOffset;

  CaseConnectionPainter({
    required this.cases,
    required this.centerOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cases.isEmpty) return;
    final Map<String, CriminalCaseModel> caseMap = {for (var c in cases) c.id: c};

    final borderPaint = Paint()
      ..color = AppColors.trackBorder
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final outerGoldPaint = Paint()
      ..color = AppColors.trackGoldOuter
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final innerGoldPaint = Paint()
      ..color = AppColors.trackGoldInner
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final lockedBorderPaint = Paint()
      ..color = AppColors.trackBorder
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final lockedInnerPaint = Paint()
      ..color = AppColors.trackLockedOuter
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var c in cases) {
      final p1 = Offset(centerOffset.dx + c.mapX, centerOffset.dy + c.mapY);

      for (var parentId in c.parentCaseIds) {
        final parent = caseMap[parentId];
        if (parent != null) {
          final p2 = Offset(centerOffset.dx + parent.mapX, centerOffset.dy + parent.mapY);

          final bool isPathActive = (c.status != CaseStatus.locked) || (parent.status == CaseStatus.completed);

          if (isPathActive) {
            canvas.drawLine(p1, p2, borderPaint);
            canvas.drawLine(p1, p2, outerGoldPaint);
            canvas.drawLine(p1, p2, innerGoldPaint);
          } else {
            canvas.drawLine(p1, p2, lockedBorderPaint);
            canvas.drawLine(p1, p2, lockedInnerPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CaseConnectionPainter oldDelegate) {
    return oldDelegate.cases != cases || oldDelegate.centerOffset != centerOffset;
  }
}
