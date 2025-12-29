import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/customers/presentation/customer_list_screen.dart';
import '../features/customers/presentation/customer_form_screen.dart';
import '../features/home/settings_screen.dart';
import '../shared/presentation/scaffold_with_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/auth_repository.dart';

part 'app_router.g.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(Ref ref) {
  final authNotifier = ValueNotifier<AsyncValue<User?>>(const AsyncLoading());
  ref.listen(authStateChangesProvider, (_, next) {
    authNotifier.value = next;
  }, fireImmediately: true);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: All Customers
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) =>
                    const CustomerListScreen(filter: 'all'),
                routes: [
                  GoRoute(
                    path: 'add',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CustomerFormScreen(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return CustomerFormScreen(customerId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Purchase
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/purchase',
                builder: (context, state) =>
                    const CustomerListScreen(filter: 'purchase'),
              ),
            ],
          ),
          // Branch 3: Repair
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/repair',
                builder: (context, state) =>
                    const CustomerListScreen(filter: 'repair'),
              ),
            ],
          ),
          // Branch 4: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ],
  );
}
