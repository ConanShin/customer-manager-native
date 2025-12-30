import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository.g.dart';

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map(
    (state) => state.session?.user,
  );
}

class AuthService {
  final SupabaseClient _supabase;
  AuthService(this._supabase);

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

final authServiceProvider = Provider(
  (ref) => AuthService(Supabase.instance.client),
);
