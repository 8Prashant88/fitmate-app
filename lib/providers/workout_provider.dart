import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import 'firestore_providers.dart';

final workoutsStreamProvider = StreamProvider<List<Workout>>((ref) {
  final fs = ref.watch(firestoreServiceProvider);
  if (fs == null) return const Stream.empty();
  return fs.watchWorkouts();
});
