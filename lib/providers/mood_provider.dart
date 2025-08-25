import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_entry.dart';
import 'firestore_providers.dart';

final moodsStreamProvider = StreamProvider<List<MoodEntry>>((ref) {
  final fs = ref.watch(firestoreServiceProvider);
  if (fs == null) return const Stream.empty();
  return fs.watchMoods();
});
