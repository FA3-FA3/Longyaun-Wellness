import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Bridges Firebase auth state into GoRouter's `refreshListenable` so route
/// guards re-evaluate on sign-in/sign-out. No-ops if Firebase hasn't been
/// initialized (e.g. in a widget test), so constructing the router never
/// throws outside a running app.
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    if (Firebase.apps.isEmpty) return;
    _subscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  StreamSubscription<User?>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
