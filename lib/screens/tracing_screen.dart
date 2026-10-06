import 'dart:math';
import 'package:flutter/material.dart';
import '../data/glyphs.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../theme.dart';

/// كتابة الحرف: حرف منقّط مع أسهم وأرقام تبيّن من أين تبدأ الكتابة
class TracingScreen extends StatefulWidget {
  final Letter letter;
  final VoidCallback? onNext;
  const TracingScreen({super.key, required this.letter, this.onNext});
  @override
  State<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen> {
  final List<List<Offset>> strokes = [];
  bool done = false;

  @override
  Widget build(BuildContext context) {
    final guide = glyphGuides[widget.letter.ch];
    return Scaffold(
      appBar: appBar('اكتب الحرف', icon: Icons.edit),
      body: Column(children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD5E5CF), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(fit: StackFit.expand, children: [
                if (guide != null)
                  CustomPaint(painter: _GuidePainter(guide))
                else
                  Center(
                    child: Text(widget.letter.ch,
                        style: TextStyle(
                            fontSize: 240,
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.bold)),
                  ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: done
                      ? null
                      : (d) => setState(() => strokes.add([d.localPosition])),
                  onPanUpdate: done
                      ? null
                      : (d) => setState(() => strokes.last.add(d.localPosition)),
                  child: CustomPaint(painter: _Painter(strokes)),
                ),
                const Positioned(
                  top: 10,
                  right: 14,
                  child: Text('ابدأ من الرقم 1 واتبع السهم',
                      style: TextStyle(fontSize: 12, color: Colors.black45)),
                ),
              ]),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                3,
                (_) => Text(widget.letter.ch,
                    style:
                        TextStyle(fontSize: 44, color: Colors.grey.shade300))),
          ),
        ),
        const SizedBox(height: 10),
        if (done)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.cream, borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [
              Text('⭐', style: TextStyle(fontSize: 34)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('أحسنت!',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.orange)),
                      Text('لقد أنهيت كتابة الحرف بشكل صحيح'),
                    ]),
              ),
            ]),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: done
              ? SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onNext?.call();
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              widget.onNext == null
                                  ? 'رجوع'
                                  : 'الانتقال إلى الدرس التالي',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ]),
                  ),
                )
              : Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(strokes.clear),
                      icon: const Icon(Icons.refresh),
                      label: const Text('مسح'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.green),
                      onPressed: strokes.isEmpty
                          ? null
                          : () {
                              Progress.i.addPoints(5);
                              setState(() => done = true);
                            },
                      icon: const Icon(Icons.check),
                      label: const Text('أنهيت الكتابة'),
                    ),
                  ),
                ]),
        ),
      ]),
    );
  }
}

/// يرسم الحرف منقّطاً + أسهم وأرقام ترتيب الكتابة
class _GuidePainter extends CustomPainter {
  final GlyphGuide g;
  _GuidePainter(this.g);

  Path _build(String d, double s, double ox, double oy) {
    final p = Path();
    final re = RegExp(r'([MLQCZ])([^MLQCZ]*)');
    for (final m in re.allMatches(d)) {
      final op = m.group(1)!;
      final body = m.group(2)!.trim();
      final n = body.isEmpty
          ? <double>[]
          : body.split(RegExp(r'[ ,]+')).map(double.parse).toList();
      double x(int i) => n[i] * s + ox;
      double y(int i) => n[i] * s + oy;
      switch (op) {
        case 'M':
          p.moveTo(x(0), y(1));
          break;
        case 'L':
          p.lineTo(x(0), y(1));
          break;
        case 'Q':
          p.quadraticBezierTo(x(0), y(1), x(2), y(3));
          break;
        case 'C':
          p.cubicTo(x(0), y(1), x(2), y(3), x(4), y(5));
          break;
        case 'Z':
          p.close();
          break;
      }
    }
    return p;
  }

  Path _dash(Path src, double dash, double gap) {
    final out = Path();
    for (final m in src.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        out.addPath(m.extractPath(d, min(d + dash, m.length)), Offset.zero);
        d += dash + gap;
      }
    }
    return out;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = min(size.width, size.height) * 0.62;
    final ox = (size.width - g.w * s) / 2;
    final oy = (size.height - g.h * s) / 2;
    final path = _build(g.path, s, ox, oy);

    canvas.drawPath(path, Paint()..color = const Color(0xFFEEF2EA));
    canvas.drawPath(
        _dash(path, 7, 6),
        Paint()
          ..color = Colors.grey.shade500
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2);

    for (final m in g.marks) {
      final pos = Offset(m.x * s + ox, m.y * s + oy);
      final color = m.arrow ? AppColors.green : AppColors.orange;
      if (m.arrow) {
        final len = sqrt(m.dx * m.dx + m.dy * m.dy);
        final ux = m.dx / len, uy = m.dy / len;
        final a = pos + Offset(ux * 14, uy * 14);
        final b = pos + Offset(ux * 50, uy * 50);
        final line = Paint()
          ..color = color
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(a, b, line);
        for (final ang in [2.6, -2.6]) {
          final ca = cos(ang), sa = sin(ang);
          final hx = ux * ca - uy * sa, hy = ux * sa + uy * ca;
          canvas.drawLine(b, b + Offset(hx * 11, hy * 11), line);
        }
      }
      canvas.drawCircle(pos, 12, Paint()..color = color);
      final tp = TextPainter(
        text: TextSpan(
            text: '${m.n}',
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _GuidePainter old) => old.g != g;
}

class _Painter extends CustomPainter {
  final List<List<Offset>> strokes;
  _Painter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.green.withAlpha(210)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final s in strokes) {
      if (s.length == 1) {
        canvas.drawCircle(s.first, 7, Paint()..color = AppColors.green);
      } else {
        final path = Path()..moveTo(s.first.dx, s.first.dy);
        for (final p in s.skip(1)) {
          path.lineTo(p.dx, p.dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _Painter old) => true;
}
