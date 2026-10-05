import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../theme.dart';
import 'shell.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final name = TextEditingController();
  final age = TextEditingController();
  final grade = TextEditingController();
  String gender = 'غير محدد';

  String inferGender(String value) {
    final n = value.trim().replaceAll('أ', 'ا').replaceAll('إ', 'ا');
    const female = ['سارة','ساره','مريم','نور','رؤى','رؤى','ليان','لين','جنى','جنا','جود','ريم','رنا','هبة','هبه','آية','ايه','سلمى','سلمي','ملك','تالا','لارا','رُبى','ربى'];
    const male = ['محمد','احمد','أحمد','محمود','عمر','علي','حسن','حسين','عبدالله','عبد الله','خالد','ياسين','يوسف','ابراهيم','إبراهيم','آدم','ادم','حمزة','حمزه','أنس','انس','زياد','سعيد','مصطفى','مصطفي'];
    if (female.any((x) => n == x.replaceAll('أ','ا').replaceAll('إ','ا'))) return 'أنثى';
    if (male.any((x) => n == x.replaceAll('أ','ا').replaceAll('إ','ا'))) return 'ذكر';
    return 'غير محدد';
  }

  Future<void> save() async {
    final a = int.tryParse(age.text) ?? 0;
    if (name.text.trim().isEmpty || a < 3 || grade.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل الاسم والعمر والصف من فضلك')));
      return;
    }
    await Progress.i.saveStudent(newName: name.text, newAge: a, newGrade: grade.text, newGender: gender);
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Shell()));
  }

  @override Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFFE9F8F0), Color(0xFFF7F3E8), Color(0xFFEAF3FF)])),
      child: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(22, 28, 22, 24), children: [
        Image.asset('assets/logo.png', height: 82),
        const SizedBox(height: 12),
        const Text('أهلاً بك في مدرستك 🌱', textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: AppColors.green)),
        const SizedBox(height: 6),
        const Text('لننشئ ملفك التعليمي لنخصص لك رحلة التعلم', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 26),
        _field(name, 'اسم الطالب', Icons.person_outline, onChanged: (v) => setState(() => gender = inferGender(v))),
        _field(age, 'العمر', Icons.cake_outlined, numeric: true),
        _field(grade, 'الصف / المستوى', Icons.school_outlined),
        const SizedBox(height: 8),
        Card(color: Colors.white.withAlpha(235), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
          const Icon(Icons.wc_outlined, color: AppColors.green), const SizedBox(width: 12),
          const Expanded(child: Text('الجنس (يُقترح تلقائياً حسب الاسم)')),
          DropdownButton<String>(value: gender, underline: const SizedBox(), items: const ['ذكر','أنثى','غير محدد'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => gender = v!)),
        ]))),
        const SizedBox(height: 20),
        FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: AppColors.green, padding: const EdgeInsets.symmetric(vertical: 16)), onPressed: save, icon: const Icon(Icons.arrow_forward_rounded), label: const Text('ابدأ رحلتي التعليمية', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10),
        const Text('يمكن تعديل البيانات لاحقاً من قسم الإدارة.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black45)),
      ])),
    ),
  );

  Widget _field(TextEditingController c, String label, IconData icon, {bool numeric=false, ValueChanged<String>? onChanged}) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextField(controller: c, onChanged: onChanged, keyboardType: numeric ? TextInputType.number : TextInputType.text, decoration: InputDecoration(prefixIcon: Icon(icon), labelText: label, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none))));
}
