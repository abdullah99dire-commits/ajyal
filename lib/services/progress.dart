import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/lessons.dart';
import '../data/surahs.dart';

class Progress extends ChangeNotifier {
  static final Progress i = Progress._();
  Progress._();

  late SharedPreferences _p;
  String name = 'طالب';
  int age = 0;
  String grade = '';
  String gender = 'غير محدد';
  int points = 0;
  String lastActivity = 'لم تبدأ بعد';
  Set<int> learned = {};
  Set<int> rashidi = {};
  Set<int> quran = {};
  List<String> activityLog = [];

  Set<int> _readSet(String k) => (_p.getStringList(k) ?? []).map(int.parse).toSet();
  void _saveSet(String k, Set<int> s) => _p.setStringList(k, s.map((e) => '$e').toList());

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    name = _p.getString('name') ?? 'طالب';
    age = _p.getInt('age') ?? 0;
    grade = _p.getString('grade') ?? '';
    gender = _p.getString('gender') ?? 'غير محدد';
    points = _p.getInt('points') ?? 0;
    lastActivity = _p.getString('activity') ?? 'لم تبدأ بعد';
    learned = _readSet('learned');
    rashidi = _readSet('rashidi');
    quran = _readSet('quran');
    activityLog = _p.getStringList('activityLog') ?? [];
    notifyListeners();
  }

  bool get isRegistered => name != 'طالب' && name.trim().isNotEmpty && age > 0 && grade.isNotEmpty;

  Future<void> saveStudent({required String newName, required int newAge, required String newGrade, required String newGender}) async {
    name = newName.trim().isEmpty ? 'طالب' : newName.trim();
    age = newAge;
    grade = newGrade.trim();
    gender = newGender;
    await _p.setString('name', name);
    await _p.setInt('age', age);
    await _p.setString('grade', grade);
    await _p.setString('gender', gender);
    notifyListeners();
  }

  void addPoints(int n) {
    points += n;
    _p.setInt('points', points);
    notifyListeners();
  }

  void _first(Set<int> set, int v, String key, int pts) {
    if (set.add(v)) {
      _saveSet(key, set);
      addPoints(pts);
    }
  }

  void markLearned(int v) => _first(learned, v, 'learned', 2);
  void markRashidi(int v) => _first(rashidi, v, 'rashidi', 3);
  void markSurah(int v) => _first(quran, v, 'quran', 3);

  void setActivity(String a) {
    lastActivity = a;
    final stamp = '${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}  ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} — $a';
    activityLog = [stamp, ...activityLog].take(50).toList();
    _p.setString('activity', a);
    _p.setStringList('activityLog', activityLog);
    notifyListeners();
  }

  void setName(String v) => saveStudent(newName: v, newAge: age, newGrade: grade, newGender: gender);


  Future<void> resetLearning() async {
    points = 0;
    learned.clear();
    rashidi.clear();
    quran.clear();
    activityLog.clear();
    await _p.setInt('points', 0);
    await _saveSet('learned', learned);
    await _saveSet('rashidi', rashidi);
    await _saveSet('quran', quran);
    await _p.setStringList('activityLog', []);
    lastActivity = 'لم تبدأ بعد';
    await _p.setString('activity', lastActivity);
    notifyListeners();
  }

  double get lettersPercent => learned.length / 28;
  double get rashidiPercent => rashidi.length / lessons.length;
  double get quranPercent => quran.length / surahs.length;
}
