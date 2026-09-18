import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';

/// Sign-in only — there is no self-serve registration. Accounts are
/// created by an admin, not by visitors.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) context.go('/dashboard');
    } on FirebaseAuthException catch (error) {
      setState(() => _errorMessage = error.message ?? error.code);
    } catch (error) {
      setState(() => _errorMessage = 'Sign-in failed: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Longyuan Wellness / 龙源养生',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.navBrand,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.navText,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: AppColors.navText),
                  decoration: _inputDecoration('Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: AppColors.navText),
                  decoration: _inputDecoration('Password'),
                  onSubmitted: (_) => _loading ? null : _submit(),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.accent, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text(
                    _loading ? 'Logging in…' : 'Log In',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.navText.withValues(alpha: 0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.navText.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.navTextActive),
      ),
    );
  }
}
