/// أسماء ملفات الصوت المسجّلة (إن وُجدت يستخدمها التطبيق، وإلا يقرأ بصوت الجهاز)
String _n(int i) => (i + 1).toString().padLeft(2, '0');

String letterAudio(int i) => 'assets/audio/letters/${_n(i)}.mp3';
String syllableAudio(int i, String k) => 'assets/audio/letters/${_n(i)}_$k.mp3';
String wordAudio(int i) => 'assets/audio/words/${_n(i)}.mp3';
String storyAudio(int i) => 'assets/audio/stories/${i + 1}.mp3';
