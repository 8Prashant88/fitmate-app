class Workout {
  Workout({required this.id, required this.uid, required this.date, required this.type, required this.durationMin, required this.calories, this.notes});
  final String? id;
  final String uid;
  final DateTime date;
  final String type;
  final int durationMin;
  final int calories;
  final String? notes;

  Map<String, dynamic> toMap() => {'uid': uid, 'date': date.toIso8601String(), 'type': type, 'durationMin': durationMin, 'calories': calories, 'notes': notes};
  static Workout fromMap(String id, Map<String, dynamic> map) => Workout(
    id: id,
    uid: map['uid'] as String,
    date: DateTime.parse(map['date'] as String),
    type: map['type'] as String,
    durationMin: (map['durationMin'] as num).toInt(),
    calories: (map['calories'] as num).toInt(),
    notes: map['notes'] as String?,
  );
}
