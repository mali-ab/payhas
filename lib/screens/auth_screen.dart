import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _signUp = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = context.read<AuthProvider>();
    final success = _signUp
        ? await auth.signUp(_name.text.trim(), _email.text.trim(), _password.text)
        : await auth.login(_email.text.trim(), _password.text);
    if (success && mounted) {
      final user = auth.user!;
      await context.read<GameProvider>().activateUser(
            id: user.id,
            name: user.name,
            avatar: user.avatar,
          );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error ?? 'Näsazlyk ýüze çykdy.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const BrandMark(size: 104),
                      const SizedBox(height: 18),
                      const Text('PAÝHAS', style: TextStyle(color: AppTheme.textPrimary, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 2)),
                      const SizedBox(height: 8),
                      Text(_signUp ? 'Hasabyňyzy dörediň' : 'Hasabyňyza giriň', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                      const SizedBox(height: 32),
                      if (_signUp) _field(controller: _name, label: 'Adyňyz', icon: Icons.person_outline, validator: (value) => value == null || value.trim().length < 2 ? 'Adyňyzy giriziň.' : null),
                      _field(controller: _email, label: 'E-poçta', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (value) => value == null || !value.contains('@') ? 'Dogry e-poçta giriziň.' : null),
                      _field(controller: _password, label: 'Parol', icon: Icons.lock_outline, obscure: _obscure, suffix: IconButton(onPressed: () => setState(() => _obscure = !_obscure), icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppTheme.textSecondary)), validator: (value) => value == null || value.length < 6 ? 'Parol azyndan 6 belgiden ybarat bolmaly.' : null),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: auth.busy ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          child: auth.busy ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(_signUp ? 'HASAP DÖRET' : 'GIR', style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: auth.busy ? null : () => setState(() => _signUp = !_signUp),
                        child: Text(_signUp ? 'Hasabyňyz barmy? Giriň' : 'Hasabyňyz ýokmy? Hasap dörediň', style: const TextStyle(color: AppTheme.accentLight)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({required TextEditingController controller, required String label, required IconData icon, required String? Function(String?) validator, TextInputType? keyboardType, bool obscure = false, Widget? suffix}) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: AppTheme.accentLight), suffixIcon: suffix, filled: true, fillColor: AppTheme.cardBg, labelStyle: const TextStyle(color: AppTheme.textSecondary), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.cardBorder))),
        ),
      );
}
