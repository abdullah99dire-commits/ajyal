import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../services/speech.dart';
import '../theme.dart';
import 'register_screen.dart';
import 'shell.dart';

/// شاشة الترحيب: خلفية المشهد (الولد والبنت) + الشعار + زر ابدأ الآن
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
    final hasBg = Speech.hasAsset('assets/images/welcome_bg.png');
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        hasBg
            ? Image.asset('assets/images/welcome_bg.png', fit: BoxFit.cover)
            : _fallbackScene(),
        SafeArea(
          child: Column(children: [
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 16, offset: Offset(0, 6))
                ],
              ),
              child: Image.asset('assets/logo.png', width: 96),
            ),
            const SizedBox(height: 8),
            const Text('المنتدى العربي الألماني',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('في مدينة Landshut',
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 10),
            const Text('المدرسة الإسلامية العربية',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green)),
            const Text('تعلم .. تربية .. قيم',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const Spacer(),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(240),
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 16, offset: Offset(0, 6))
                ],
              ),
              child: Column(children: [
                const Text('مرحباً بك في تطبيق مدرستك الإسلامية',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const Text('هيا نبدأ رحلة التعلم معاً'),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    onPressed: () => _start(context),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ابدأ الآن',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right),
                        ]),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}
