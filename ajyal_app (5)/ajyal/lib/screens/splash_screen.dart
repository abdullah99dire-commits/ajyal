import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';
import 'register_screen.dart';
import 'shell.dart';

/// شاشة الترحيب: خلفية المشهد (الولد والبنت) + الشعار + زر ابدأ الآن
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const _ink = Color(0xFF0F5A3A);
  static const _gold = Color(0xFFD9B766);

  Widget _glow(String t, double size, FontWeight w, Color c) => Text(t,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: size,
          fontWeight: w,
          color: c,
          height: 1.35,
          shadows: const [
            Shadow(color: Colors.white70, blurRadius: 10),
            Shadow(color: Colors.white54, blurRadius: 4),
          ]));

  Widget _cloud(double w) => Container(
        width: w,
        height: w * 0.38,
        decoration: BoxDecoration(
            color: Colors.white.withAlpha(190),
            borderRadius: BorderRadius.circular(w)),
      );

  Widget _hill(Color c, double h) => Container(
        height: h,
        decoration: BoxDecoration(
            color: c,
            borderRadius:
                const BorderRadius.vertical(top: Radius.elliptical(500, 140))),
      );

  /// بديل بسيط يظهر إلى أن تضع صورة welcome_bg.png
  Widget _fallbackScene() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9FD8FF), Color(0xFFE3F4FF), Color(0xFFEAF6D8)],
          ),
        ),
        child: Stack(children: [
          Positioned(top: 90, right: -30, child: _cloud(130)),
          Positioned(top: 170, left: -40, child: _cloud(150)),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _hill(const Color(0xFFBFE3A3), 260)),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _hill(const Color(0xFF9FD17F), 190)),
          const Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Text('🧒🏻👧🏻', style: TextStyle(fontSize: 90)))),
        ]),
      );

  void _start(BuildContext context) => Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) =>
              Progress.i.registered ? const Shell() : const RegisterScreen()));

  @override
  Widget build(BuildContext context) {
    final bg = Speech.hasAsset('assets/images/welcome_bg.jpg')
        ? 'assets/images/welcome_bg.jpg'
        : (Speech.hasAsset('assets/images/welcome_bg.png')
            ? 'assets/images/welcome_bg.png'
            : null);
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        bg != null
            ? Image.asset(bg, fit: BoxFit.cover, alignment: Alignment.center)
            : _fallbackScene(),
        SafeArea(
          child: Column(children: [
            const SizedBox(height: 16),
            Container(
              width: 118,
              height: 118,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 18, offset: Offset(0, 6))
                ],
              ),
              child: ClipOval(child: Image.asset('assets/logo.png', fit: BoxFit.cover)),
            ),
            const SizedBox(height: 10),
            _glow('المنتدى العربي الألماني', 21, FontWeight.bold, _ink),
            _glow('في مدينة لاندهوت', 15, FontWeight.w600, Colors.black87),
            const SizedBox(height: 8),
            _glow('المدرسة الإسلامية العربية', 28, FontWeight.w800, _ink),
            _glow('تعلم .. تربية .. قيم', 17, FontWeight.w600, _ink),
            const Spacer(),
            Container(
              margin: const EdgeInsets.fromLTRB(22, 0, 22, 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E8),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _gold, width: 2.2),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 16, offset: Offset(0, 6))
                ],
              ),
              child: const Text(
                  'مرحباً بك في تطبيق مدرستك الإسلامية\nمعاً نجعل من التعلم رحلة أجمل',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700, height: 1.7)),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(52, 6, 52, 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: _gold, width: 2.6),
                gradient: const LinearGradient(
                    colors: [Color(0xFF0F6B45), Color(0xFF0A4F34)]),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black38, blurRadius: 14, offset: Offset(0, 6))
                ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(34),
                  onTap: () => _start(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ابدأ الآن',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Colors.white, size: 28),
                        ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
