import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

final uidProvider = Provider<String?>((ref) => FirebaseAuth.instance.currentUser?.uid);

final firestoreServiceProvider = Provider<FirestoreService?>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return null;
  return FirestoreService(uid);
});
