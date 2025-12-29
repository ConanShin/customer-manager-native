import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

class AuthService {
  final FirebaseAuth _auth;
  AuthService(this._auth);

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

final authServiceProvider = Provider(
  (ref) => AuthService(FirebaseAuth.instance),
);
