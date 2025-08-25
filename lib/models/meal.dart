class Meal {
  Meal({required this.id, required this.uid, required this.date, required this.items, required this.calories, this.protein, this.carbs, this.fat, this.waterMl, this.notes});
  final String? id;
  final String uid;
  final DateTime date;
  final List<String> items;
  final int calories;
  final int? protein;
  final int? carbs;
  final int? fat;
  final int? waterMl;
  final String? notes;

  Map<String, dynamic> toMap() => {'uid': uid, 'date': date.toIso8601String(), 'items': items, 'calories': calories, 'protein': protein, 'carbs': carbs, 'fat': fat, 'waterMl': waterMl, 'notes': notes};
  static Meal fromMap(String id, Map<String, dynamic> map) => Meal(
    id: id,
    uid: map['uid'] as String,
    date: DateTime.parse(map['date'] as String),
    items: (map['items'] as List).map((e) => e.toString()).toList(),
    calories: (map['calories'] as num).toInt(),
    protein: (map['protein'] as num?)?.toInt(),
    carbs: (map['carbs'] as num?)?.toInt(),
    fat: (map['fat'] as num?)?.toInt(),
    waterMl: (map['waterMl'] as num?)?.toInt(),
    notes: map['notes'] as String?,
  );
}
