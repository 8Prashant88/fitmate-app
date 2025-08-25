class MoodEntry {
  MoodEntry({required this.id, required this.uid, required this.date, required this.mood, this.note});
  final String? id;
  final String uid;
  final DateTime date;
  final String mood;
  final String? note;

  Map<String, dynamic> toMap() => {'uid': uid, 'date': date.toIso8601String(), 'mood': mood, 'note': note};
  static MoodEntry fromMap(String id, Map<String, dynamic> map) => MoodEntry(
    id: id,
    uid: map['uid'] as String,
    date: DateTime.parse(map['date'] as String),
    mood: map['mood'] as String,
    note: map['note'] as String?,
  );
}
