import 'package:flutter/material.dart';
import '../theme.dart';
import 'shell.dart';

/// شاشة الشعار عند فتح التطبيق
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Shell()));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset('assets/logo.png', width: 200),
            const SizedBox(height: 24),
            const Text('المنتدى العربي الألماني',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('في مدينة Landshut',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: AppColors.green),
          ]),
        ),
      );
}
