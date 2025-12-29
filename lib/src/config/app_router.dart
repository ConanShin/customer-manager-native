import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/customers/presentation/customer_list_screen.dart';
import '../features/customers/presentation/customer_form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/auth/data/auth_repository.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final authNotifier = ValueNotifier<AsyncValue<User?>>(const AsyncLoading());
  ref.listen(authStateChangesProvider, (_, next) {
    authNotifier.value = next;
  }, fireImmediately: true);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);

      // Don't redirect while loading the initial auth state
      if (authState.isLoading) return null;

      final user = authState.value;
      final isLoggedIn = user != null;
      final isLoggingIn = state.uri.path == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CustomerListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const CustomerFormScreen(),
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return CustomerFormScreen(customerId: id);
            },
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ],
  );
}
