// lib/features/auth/presentation/pages/auth_page.dart

import 'package:flutter/material.dart';
import '../../../../core/session/app_session.dart';
import '../../data/services/user_api_service.dart';
import '../../../home/presentation/pages/home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  final _signupEmail = TextEditingController();
  final _signupPassword = TextEditingController();

  final _service = UserApiService();
  bool _loading = false;

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    _signupEmail.dispose();
    _signupPassword.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_loginKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = await _service.login(
        _loginEmail.text.trim(),
        _loginPassword.text.trim(),
      );
      AppSession.currentUserId = user.id;
      AppSession.currentEmail = user.email;
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleSignup() async {
    if (!_signupKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = await _service.signup(
        _signupEmail.text.trim(),
        _signupPassword.text.trim(),
      );
      AppSession.currentUserId = user.id;
      AppSession.currentEmail = user.email;
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Login'),
              Tab(text: 'Sign up'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AuthForm(
              formKey: _loginKey,
              emailController: _loginEmail,
              passwordController: _loginPassword,
              buttonLabel: _loading ? 'Loading...' : 'Login',
              onSubmit: _loading ? null : _handleLogin,
            ),
            _AuthForm(
              formKey: _signupKey,
              emailController: _signupEmail,
              passwordController: _signupPassword,
              buttonLabel: _loading ? 'Loading...' : 'Create account',
              onSubmit: _loading ? null : _handleSignup,
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.buttonLabel,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String buttonLabel;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSubmit,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
