import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../core/constants/app_colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.read<SupabaseService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.goldBright),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.surfaceBorder, height: 1.0),
        ),
        title: Text(
          _isSignUp ? 'CREDENCIAMENTO DE DETETIVE' : 'IDENTIFICAÇÃO DE AGENTE',
          style: GoogleFonts.cinzel(color: AppColors.goldBright, fontSize: 16),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.goldBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.goldBorder),
                      ),
                      child: const Icon(Icons.fingerprint, size: 48, color: AppColors.goldBright),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'AGÊNCIA CASE FILES',
                      style: GoogleFonts.cinzel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldBright,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Acesso confidencial ao arquivo de casos',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF451A1A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE63946)),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_isSignUp) ...[
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Codinome / Nome do Agente', Icons.badge),
                    ),
                    const SizedBox(height: 14),
                  ],

                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('E-mail institucional', Icons.email),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: _inputDecoration('Senha de acesso', Icons.lock),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: AppColors.goldBright),
                        ),
                      ),
                      onPressed: _isLoading ? null : () => _submit(service),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              _isSignUp ? 'REGISTRAR CREDENCIAL' : 'ACESSAR ARQUIVOS',
                              style: GoogleFonts.cinzel(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                        _errorMessage = null;
                      });
                    },
                    child: Text(
                      _isSignUp
                          ? 'Já possui credencial? Fazer login'
                          : 'Novo agente na agência? Cadastre-se',
                      style: GoogleFonts.montserrat(
                        color: AppColors.goldBright,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.montserrat(color: AppColors.textMuted, fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.goldBorder, size: 20),
      filled: true,
      fillColor: AppColors.background,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.surfaceBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.goldBright),
      ),
    );
  }

  Future<void> _submit(SupabaseService service) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        throw 'Preencha todos os campos obrigatórios.';
      }

      if (_isSignUp) {
        final username = _usernameController.text.trim();
        await service.signUp(
          email: email,
          password: password,
          username: username.isEmpty ? email.split('@').first : username,
        );
      } else {
        await service.signIn(email: email, password: password);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
