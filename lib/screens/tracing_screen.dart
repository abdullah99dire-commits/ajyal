import 'package:flutter/material.dart';
import '../data/letters.dart';
import '../services/progress.dart';
import '../theme.dart';

/// كتابة الحرف بالإصبع فوق حرف إرشادي باهت
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
  Widget build(BuildContext context) => Scaffold(
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
                ]),
              ),
            ),
          ),
          // سطور التدريب
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
                      style: TextStyle(
                          fontSize: 44, color: Colors.grey.shade300))),
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
