import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// تقدم الطالب (محفوظ على الجهاز)
class Progress extends ChangeNotifier {
  static final Progress i = Progress._();
  Progress._();

  late SharedPreferences _p;
  String name = 'طالب';
  int points = 0;
  Set<int> learned = {};

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    name = _p.getString('name') ?? 'طالب';
    points = _p.getInt('points') ?? 0;
    learned = (_p.getStringList('learned') ?? []).map(int.parse).toSet();
    notifyListeners();
  }

  void addPoints(int n) {
    points += n;
    _p.setInt('points', points);
    notifyListeners();
  }

  void markLearned(int index) {
    if (learned.add(index)) {
      _p.setStringList('learned', learned.map((e) => '$e').toList());
      addPoints(2);
    }
  }

  void setName(String v) {
    name = v.trim().isEmpty ? 'طالب' : v.trim();
    _p.setString('name', name);
    notifyListeners();
  }

  double get lettersPercent => learned.length / 28;
}
