import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import 'firestore_providers.dart';

final mealsStreamProvider = StreamProvider<List<Meal>>((ref) {
  final fs = ref.watch(firestoreServiceProvider);
  if (fs == null) return const Stream.empty();
  return fs.watchMeals();
});
