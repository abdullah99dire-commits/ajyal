import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../theme.dart';

/// كتابة الحرف بالإصبع فوق حرف إرشادي باهت
class TracingScreen extends StatefulWidget {
  final Letter letter;
  const TracingScreen({super.key, required this.letter});
  @override
  State<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen> {
  final List<List<Offset>> strokes = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar('اكتب الحرف'),
        body: Column(children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.green2, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(fit: StackFit.expand, children: [
                  Center(
                    child: Text(widget.letter.ch,
                        style: TextStyle(
                            fontSize: 260,
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.bold)),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (d) =>
                        setState(() => strokes.add([d.localPosition])),
                    onPanUpdate: (d) =>
                        setState(() => strokes.last.add(d.localPosition)),
                    child: CustomPaint(painter: _Painter(strokes)),
                  ),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(children: [
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
                  onPressed: strokes.isEmpty
                      ? null
                      : () {
                          Progress.i.addPoints(5);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('أحسنت! +5 نقاط ⭐')));
                          setState(strokes.clear);
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

class _Painter extends CustomPainter {
  final List<List<Offset>> strokes;
  _Painter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.green
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final s in strokes) {
      if (s.length == 1) {
        canvas.drawCircle(s.first, 7, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
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
