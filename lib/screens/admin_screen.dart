import 'package:flutter/material.dart';
import '../services/progress.dart';
import '../theme.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override State<AdminScreen> createState() => _AdminScreenState();
}
class _AdminScreenState extends State<AdminScreen> {
  bool unlocked = false;
  final pin = TextEditingController();
  void _login() {
    if (pin.text == '1234') setState(() => unlocked = true);
    else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رمز الإدارة غير صحيح')));
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: appBar('لوحة الإدارة', icon: Icons.admin_panel_settings_rounded),
    body: !unlocked ? _loginView() : ListenableBuilder(listenable: Progress.i, builder: (_, __) => ListView(padding: const EdgeInsets.all(16), children: [
      _header(),
      const SizedBox(height: 14),
      Row(children: [_stat('${Progress.i.name}', 'الطالب الحالي', Icons.person), _stat('${Progress.i.points}', 'النقاط', Icons.star)]),
      Row(children: [_stat('${Progress.i.learned.length}/28', 'الحروف', Icons.translate), _stat('${Progress.i.activityLog.length}', 'النشاطات المسجلة', Icons.history)]),
      const SizedBox(height: 12),
      Card(child: Column(children: [ListTile(leading: const Icon(Icons.edit_note, color: AppColors.green), title: const Text('تعديل بيانات الطالب'), onTap: () => _editStudent()), const Divider(height: 1), ListTile(leading: const Icon(Icons.refresh, color: AppColors.orange), title: const Text('تصفير التقدم على هذا الجهاز'), onTap: () => _confirmReset())])),
      const SizedBox(height: 12),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('سجل المشاركة والنشاط', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 10), if (Progress.i.activityLog.isEmpty) const Text('لا توجد نشاطات بعد') else ...Progress.i.activityLog.map((x) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.check_circle, size: 17, color: AppColors.green2), const SizedBox(width: 8), Expanded(child: Text(x))])))]))),
      const SizedBox(height: 10),
      const Text('ملاحظة: هذه النسخة تسجل بيانات الطالب والنشاط محلياً على جهازه. لمشاركة بيانات جميع الطلاب مع الإدارة عبر أجهزة مختلفة، نحتاج ربطاً سحابياً مثل Firebase/Supabase.', style: TextStyle(color: Colors.black54, fontSize: 12)),
    ])),
  );

  Widget _loginView() => Center(child: SingleChildScrollView(padding: const EdgeInsets.all(28), child: Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [const Icon(Icons.admin_panel_settings_rounded, size: 60, color: AppColors.green), const SizedBox(height: 12), const Text('دخول الإدارة', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 18), TextField(controller: pin, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'رمز الإدارة', prefixIcon: Icon(Icons.lock_outline))), const SizedBox(height: 14), SizedBox(width: double.infinity, child: FilledButton(onPressed: _login, child: const Text('دخول'))), const SizedBox(height: 8), const Text('الرمز التجريبي: 1234', style: TextStyle(color: Colors.black45, fontSize: 12))]))));
  Widget _header() => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.green, AppColors.green2]), borderRadius: BorderRadius.circular(24)), child: const Row(children: [Icon(Icons.dashboard_rounded, color: Colors.white, size: 38), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مركز التحكم', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text('مراجعة البيانات والتقدم والنشاط', style: TextStyle(color: Colors.white70))]))]));
  Widget _stat(String value, String label, IconData icon) => Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(13), child: Column(children: [Icon(icon, color: AppColors.green), const SizedBox(height: 4), Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54))]))));
  Future<void> _editStudent() async {
    final n = TextEditingController(text: Progress.i.name); final a = TextEditingController(text: '${Progress.i.age}'); final g = TextEditingController(text: Progress.i.grade);
    String sex = Progress.i.gender;
    await showDialog(context: context, builder: (_) => StatefulBuilder(builder: (c, set) => AlertDialog(title: const Text('تعديل بيانات الطالب'), content: SingleChildScrollView(child: Column(children: [TextField(controller: n, decoration: const InputDecoration(labelText: 'الاسم')), TextField(controller: a, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'العمر')), TextField(controller: g, decoration: const InputDecoration(labelText: 'الصف')), DropdownButtonFormField<String>(value: sex, decoration: const InputDecoration(labelText: 'الجنس'), items: const ['ذكر','أنثى','غير محدد'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(), onChanged: (x) => set(() => sex = x!))])), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('إلغاء')), FilledButton(onPressed: () async { await Progress.i.saveStudent(newName: n.text, newAge: int.tryParse(a.text) ?? 0, newGrade: g.text, newGender: sex); if (mounted) Navigator.pop(c); }, child: const Text('حفظ'))])));
  }
  Future<void> _confirmReset() async { final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('تأكيد التصفير'), content: const Text('سيتم تصفير النقاط والتقدم والنشاطات المسجلة.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('تصفير'))])); if (ok == true) { await Progress.i.resetLearning(); Progress.i.setActivity('تم تصفير التقدم بواسطة الإدارة'); setState(() {}); } }
}
