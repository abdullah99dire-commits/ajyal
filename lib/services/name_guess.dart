/// يقترح صورة رمزية (boy / girl) من الاسم الأول.
/// الاقتراح تقريبي دائماً (هناك أسماء مشتركة وأسماء أجنبية)،
/// لذلك يؤكده الطالب أو يغيّره بنفسه، ولا نحفظ إلا الصورة الرمزية.
String? guessAvatar(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return null;
  final n = parts.first
      .toLowerCase()
      .replaceAll(RegExp(r'[\u064B-\u0652]'), '')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا');

  const boys = {
    'محمد', 'احمد', 'علي', 'عمر', 'يوسف', 'ابراهيم', 'اسماعيل', 'خالد', 'حسن',
    'حسين', 'عثمان', 'بلال', 'حمزة', 'اسامة', 'طلحة', 'معاذ', 'زيد', 'سعد',
    'ياسين', 'يحيى', 'موسى', 'عيسى', 'مصطفى', 'مرتضى', 'عبد', 'عبدالله',
    'عبدالرحمن', 'ادم', 'نوح', 'انس', 'ايمن', 'امين', 'سليمان', 'داود',
    'هارون', 'زكريا', 'حذيفة', 'عبيدة', 'معاوية', 'مالك', 'كريم', 'طارق',
    'سامر', 'سمير', 'جمال', 'محمود', 'عادل', 'رامي', 'فادي', 'ماجد', 'وليد',
    'mohammed', 'muhammad', 'mohamed', 'ahmad', 'ahmed', 'omar', 'umar', 'ali',
    'yusuf', 'yousef', 'youssef', 'ibrahim', 'khaled', 'khalid', 'hassan',
    'hussein', 'osama', 'bilal', 'hamza', 'said', 'samir', 'adam', 'noah',
    'anas', 'ayman', 'amir', 'tarek', 'tariq', 'mahmoud', 'mustafa', 'karim',
    'kareem', 'jamal', 'abdullah', 'abdallah', 'abdul',
  };
  const girls = {
    'مريم', 'فاطمة', 'عائشة', 'زينب', 'سارة', 'ليلى', 'سلمى', 'هدى', 'امينة',
    'اية', 'رنا', 'لينا', 'ريم', 'جنى', 'دانية', 'رهف', 'تالا', 'ميرا', 'هبة',
    'خديجة', 'اسماء', 'ايمان', 'رقية', 'حفصة', 'سمية', 'مروة', 'ياسمين', 'شهد',
    'لمى', 'ملك', 'سجى', 'رزان', 'ديما', 'لانا', 'رغد', 'هناء', 'نادية', 'امل',
    'maryam', 'mariam', 'fatima', 'fatma', 'aisha', 'aysha', 'sara', 'sarah',
    'layla', 'laila', 'zainab', 'zeynep', 'amina', 'hana', 'lina', 'rima',
    'hiba', 'yasmin', 'malak',
  };

  if (boys.contains(n)) return 'boy';
  if (girls.contains(n)) return 'girl';
  if (n.endsWith('ة') || n.endsWith('اء') || n.endsWith('ى')) return 'girl';
  return null; // غير معروف: يختار الطالب
}
