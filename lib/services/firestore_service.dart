import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout.dart';
import '../models/meal.dart';
import '../models/mood_entry.dart';

class FirestoreService {
  FirestoreService(this.uid);
  final String uid;
  final _db = FirebaseFirestore.instance;

  Stream<List<Workout>> watchWorkouts() {
    return _db.collection('workouts').where('uid', isEqualTo: uid).orderBy('date', descending: true)
      .snapshots().map((s) => s.docs.map((d) => Workout.fromMap(d.id, d.data())).toList());
  }
  Future<void> addWorkout(Workout w) => _db.collection('workouts').add(w.toMap());
  Future<void> updateWorkout(Workout w) => _db.collection('workouts').doc(w.id).update(w.toMap());
  Future<void> deleteWorkout(String id) => _db.collection('workouts').doc(id).delete();

  Stream<List<Meal>> watchMeals() {
    return _db.collection('meals').where('uid', isEqualTo: uid).orderBy('date', descending: true)
      .snapshots().map((s) => s.docs.map((d) => Meal.fromMap(d.id, d.data())).toList());
  }
  Future<void> addMeal(Meal m) => _db.collection('meals').add(m.toMap());
  Future<void> updateMeal(Meal m) => _db.collection('meals').doc(m.id).update(m.toMap());
  Future<void> deleteMeal(String id) => _db.collection('meals').doc(id).delete();

  Stream<List<MoodEntry>> watchMoods() {
    return _db.collection('moods').where('uid', isEqualTo: uid).orderBy('date', descending: true)
      .snapshots().map((s) => s.docs.map((d) => MoodEntry.fromMap(d.id, d.data())).toList());
  }
  Future<void> addMood(MoodEntry m) => _db.collection('moods').add(m.toMap());
  Future<void> updateMood(MoodEntry m) => _db.collection('moods').doc(m.id).update(m.toMap());
  Future<void> deleteMood(String id) => _db.collection('moods').doc(id).delete();
}
