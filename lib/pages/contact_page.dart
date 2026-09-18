import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/api_config.dart';
import '../utils/app_colors.dart';

enum _SubmitStatus { idle, sending, success, error }

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  _SubmitStatus _status = _SubmitStatus.idle;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _status = _SubmitStatus.sending;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/contact'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'message': _messageController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        setState(() => _status = _SubmitStatus.success);
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _status = _SubmitStatus.error;
          _errorMessage = body['error'] as String? ?? 'Failed to send message.';
        });
      }
    } catch (_) {
      setState(() {
        _status = _SubmitStatus.error;
        _errorMessage = 'Could not reach the server. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sending = _status == _SubmitStatus.sending;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Contact',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Send a message and we\'ll get back to you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.text(context).withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration(context, 'Name'),
                  style: TextStyle(color: AppColors.text(context)),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(context, 'Email'),
                  style: TextStyle(color: AppColors.text(context)),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return 'Please enter your email';
                    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(trimmed)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  maxLines: 6,
                  decoration: _inputDecoration(context, 'Message'),
                  style: TextStyle(color: AppColors.text(context)),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Please enter a message' : null,
                ),
                if (_status == _SubmitStatus.error) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage ?? 'Something went wrong.',
                    style: const TextStyle(color: AppColors.accent, fontSize: 13),
                  ),
                ],
                if (_status == _SubmitStatus.success) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Message sent — thank you! We\'ll be in touch soon.',
                    style: TextStyle(color: AppColors.primary(context), fontSize: 13),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: sending ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text(
                    sending ? 'Sending…' : 'Send Message',
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

  InputDecoration _inputDecoration(BuildContext context, String label) {
    final textColor = AppColors.text(context);
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.primary(context)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.accent),
      ),
    );
  }
}
