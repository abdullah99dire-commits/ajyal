import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';

/// تبويبات على شكل أقراص (مثل التصميم)
class PillTabs extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final Color color;
  const PillTabs(
      {super.key,
      required this.labels,
      required this.index,
      required this.onChanged,
      this.color = AppColors.green2});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: List.generate(
            labels.length,
            (i) => Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: i == index ? color : Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(labels[i],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: i == index ? Colors.white : Colors.black54)),
                ),
              ),
            ),
          ),
        ),
      );
}

/// حلقة تقدم دائرية مع نسبة مئوية
class Ring extends StatelessWidget {
  final double value;
  final Color color;
  final String label;
  const Ring(
      {super.key, required this.value, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Column(children: [
        SizedBox(
          width: 68,
          height: 68,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 7,
                color: color,
                backgroundColor: color.withAlpha(40),
              ),
            ),
            Text('${(value * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]);
}

/// صورة الطالب: boy.png / girl.png إن وُجدت، وإلا رمز تعبيري
class Avatar extends StatelessWidget {
  final String type; // boy | girl | ''
  final double radius;
  const Avatar({super.key, required this.type, this.radius = 26});

  @override
  Widget build(BuildContext context) {
    final emoji = type == 'girl' ? '👧' : (type == 'boy' ? '👦' : '🧒');
    final file = type == 'girl' ? 'girl' : 'boy';
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFD7ECFF),
      child: ClipOval(
        child: Image.asset('assets/images/$file.png',
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Text(emoji, style: TextStyle(fontSize: radius * 1.05))),
      ),
    );
  }
}

/// صورة الكلمة: assets/images/words/NN.png إن وُجدت، وإلا رمز تعبيري
class WordPic extends StatelessWidget {
  final int index;
  final String emoji;
  final double size;
  const WordPic(
      {super.key, required this.index, required this.emoji, this.size = 60});

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/words/${(index + 1).toString().padLeft(2, '0')}.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            Text(emoji, style: TextStyle(fontSize: size * 0.9)),
      );
}


/// يصغر قليلاً عند اللمس (إحساس لعبة)
class Bouncy extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const Bouncy({super.key, required this.child, this.onTap});
  @override
  State<Bouncy> createState() => _BouncyState();
}

class _BouncyState extends State<Bouncy> {
  double scale = 1;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => scale = 0.94),
        onTapCancel: () => setState(() => scale = 1),
        onTapUp: (_) => setState(() => scale = 1),
        onTap: widget.onTap,
        child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 110),
            child: widget.child),
      );
}

/// حركة طفو خفيفة للشخصيات والنجوم
class Floaty extends StatefulWidget {
  final Widget child;
  final double dy;
  final Duration duration;
  const Floaty(
      {super.key,
      required this.child,
      this.dy = 8,
      this.duration = const Duration(milliseconds: 1800)});
  @override
  State<Floaty> createState() => _FloatyState();
}

class _FloatyState extends State<Floaty> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration)
        ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        child: widget.child,
        builder: (_, child) => Transform.translate(
            offset: Offset(0, (_c.value - 0.5) * 2 * widget.dy), child: child),
      );
}

/// أيقونة رمز تعبيري داخل دائرة ملونة
class EmojiBadge extends StatelessWidget {
  final String emoji;
  final Color color;
  final double size;
  const EmojiBadge(
      {super.key, required this.emoji, required this.color, this.size = 56});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
                color: color.withAlpha(90),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
      );
}

/// ثلاث نجوم (ممتلئة أو فارغة)
class StarsRow extends StatelessWidget {
  final int stars;
  final double size;
  const StarsRow({super.key, required this.stars, this.size = 22});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            3,
            (i) => Icon(
                i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: i < stars ? AppColors.gold : Colors.black26,
                size: size)),
      );
}

/// انفجار نجوم احتفالي مرة واحدة
class StarBurst extends StatelessWidget {
  const StarBurst({super.key});

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOut,
          builder: (_, t, __) => LayoutBuilder(builder: (_, cons) {
            final cx = cons.maxWidth / 2, cy = cons.maxHeight / 3;
            return Stack(children: [
              for (var i = 0; i < 16; i++)
                Positioned(
                  left: cx + cos(i * 2 * pi / 16) * t * cons.maxWidth * 0.48 - 14,
                  top: cy + sin(i * 2 * pi / 16) * t * cons.maxHeight * 0.34 - 14,
                  child: Opacity(
                    opacity: (1 - t).clamp(0.0, 1.0).toDouble(),
                    child: Text(i.isEven ? '⭐' : '✨',
                        style: TextStyle(fontSize: 22 + 10 * (1 - t))),
                  ),
                ),
            ]);
          }),
        ),
      );
}
