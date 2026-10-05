import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/lessons.dart';
import '../data/surahs.dart';

/// تقدم الطالب (محفوظ على الجهاز)
class Progress extends ChangeNotifier {
  static final Progress i = Progress._();
  Progress._();

  late SharedPreferences _p;
  String name = 'طالب';
  int points = 0;
  String lastActivity = 'لم تبدأ بعد';
  Set<int> learned = {};
  Set<int> rashidi = {};
  Set<int> quran = {};

  Set<int> _readSet(String k) =>
      (_p.getStringList(k) ?? []).map(int.parse).toSet();
  void _saveSet(String k, Set<int> s) =>
      _p.setStringList(k, s.map((e) => '$e').toList());

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    name = _p.getString('name') ?? 'طالب';
    points = _p.getInt('points') ?? 0;
    lastActivity = _p.getString('activity') ?? 'لم تبدأ بعد';
    learned = _readSet('learned');
    rashidi = _readSet('rashidi');
    quran = _readSet('quran');
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
    if (a == lastActivity) return;
    lastActivity = a;
    _p.setString('activity', a);
    notifyListeners();
  }

  void setName(String v) {
    name = v.trim().isEmpty ? 'طالب' : v.trim();
    _p.setString('name', name);
    notifyListeners();
  }

  double get lettersPercent => learned.length / 28;
  double get rashidiPercent => rashidi.length / lessons.length;
  double get quranPercent => quran.length / surahs.length;
}
