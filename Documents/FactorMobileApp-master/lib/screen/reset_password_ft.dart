import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordFT extends StatefulWidget {
  const ResetPasswordFT({super.key});

  @override
  State<ResetPasswordFT> createState() => _ResetPasswordFTState();
}

class _ResetPasswordFTState extends State<ResetPasswordFT> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Color backgroundColor = const Color(0xFFfcfcfc);
  final Color inputFillColor = const Color(0xFFf2f0f0);
  final Color borderColor = const Color(0xFFc2c2c2);
  final Color greenAccent = const Color(0xFF4cceac);
  final Color textColor = const Color(0xFF141414);

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleSubmit() async {
    if (_codeController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      if (mounted) {
        setState(() => _errorMessage = 'Tous les champs sont obligatoires');
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.changePassword(
        _codeController.text,
        _newPasswordController.text,
        _confirmPasswordController.text,
        auth.user!.token,
      );

      if (mounted) Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: greenAccent),
                  const SizedBox(height: 24),
                  Text(
                    "Réinitialiser le mot de passe",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  
                  _buildInputField(
                    label: "Code de vérification",
                    controller: _codeController,
                    icon: Icons.confirmation_number_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: "Nouveau mot de passe",
                    controller: _newPasswordController,
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: "Confirmer le mot de passe",
                    controller: _confirmPasswordController,
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _isLoading ? null : _handleSubmit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Réinitialiser le mot de passe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.8)),
        filled: true,
        fillColor: inputFillColor,
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: greenAccent, width: 2),
        ),
      ),
    );
  }
}
