import '../widgets.dart';
import 'package:flutter/material.dart';
import '../services/name_guess.dart';
import '../services/progress.dart';
import '../theme.dart';
import 'shell.dart';

/// تسجيل الطالب عند أول فتح: الاسم والعمر والصف.
/// الصورة الرمزية تُقترح تلقائياً من الاسم ويؤكدها الطالب أو يغيّرها.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const grades = [
    'روضة', 'الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس', 'السادس',
    'السابع', 'الثامن فما فوق'
  ];

  final _name = TextEditingController();
  int? age;
  String? grade;
  String? avatar;
  bool avatarTouched = false;
  bool consent = false;

  bool get valid =>
      _name.text.trim().length >= 2 &&
      age != null &&
      grade != null &&
      avatar != null &&
      consent;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await Progress.i.register(
        name: _name.text, age: age!, grade: grade!, avatar: avatar!);
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Shell()));
  }

  Widget _avatarChip(String key, String emoji, String label) {
    final on = avatar == key;
    return GestureDetector(
      onTap: () => setState(() {
        avatar = key;
        avatarTouched = true;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: on ? AppColors.green2.withAlpha(35) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: on ? AppColors.green2 : Colors.transparent, width: 2),
        ),
        child: Column(children: [
          Avatar(type: key, radius: 34),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.green2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFDDF1FF), Color(0xFFF4F8EE)],
            ),
          ),
          child: SafeArea(
            child: ListView(padding: const EdgeInsets.all(20), children: [
              Center(child: Image.asset('assets/logo.png', width: 84)),
              const SizedBox(height: 8),
              const Text('أهلاً بك! عرّفنا على نفسك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green)),
              const Text('نجهّز لك رحلة التعلم',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 14,
                        offset: Offset(0, 6))
                  ],
                ),
                child: Column(children: [
                  TextField(
                    controller: _name,
                    maxLength: 30,
                    textInputAction: TextInputAction.next,
                    decoration:
                        _dec('اسمك', Icons.person).copyWith(counterText: ''),
                    onChanged: (v) => setState(() {
                      if (!avatarTouched) avatar = guessAvatar(v);
                    }),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    initialValue: age,
                    decoration: _dec('عمرك', Icons.cake),
                    items: [
                      for (var a = 4; a <= 16; a++)
                        DropdownMenuItem(value: a, child: Text('$a سنة'))
                    ],
                    onChanged: (v) => setState(() => age = v),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: grade,
                    decoration: _dec('صفّك', Icons.school),
                    items: [
                      for (final g in grades)
                        DropdownMenuItem(
                            value: g, child: Text(g == 'روضة' ? g : 'الصف $g'))
                    ],
                    onChanged: (v) => setState(() => grade = v),
                  ),
                  const SizedBox(height: 18),
                  const Text('صورتك الرمزية',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    avatar == null
                        ? 'اكتب اسمك أو اختر الصورة المناسبة'
                        : avatarTouched
                            ? 'تم الاختيار'
                            : 'اخترنا لك صورة من اسمك، غيّرها إن لم تناسبك',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _avatarChip('boy', '👦', 'ولد'),
                    const SizedBox(width: 16),
                    _avatarChip('girl', '👧', 'بنت'),
                  ]),
                ]),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                value: consent,
                onChanged: (v) => setState(() => consent = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                    'أوافق أنا (أو ولي أمري) على حفظ الاسم والعمر والصف لأغراض التعلم في المدرسة فقط.',
                    style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: valid ? _submit : null,
                child: const Text('ابدأ التعلم',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ]),
          ),
        ),
      );
}
