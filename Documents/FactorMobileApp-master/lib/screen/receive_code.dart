import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiveCodePage extends StatefulWidget {
  const ReceiveCodePage({super.key});

  @override
  State<ReceiveCodePage> createState() => _ReceiveCodePageState();
}

class _ReceiveCodePageState extends State<ReceiveCodePage> {
  final TextEditingController _codeController = TextEditingController();

  final Color backgroundColor = const Color(0xFFfcfcfc); // Fond général
  final Color inputFillColor = const Color(0xFFf2f0f0); // primary[400]
  final Color borderColor = const Color(0xFFc2c2c2); // grey[800]
  final Color greenAccent = const Color(0xFF4cceac); // greenAccent[500]
  final Color textColor = const Color(0xFF141414); // Texte foncé

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleSubmit(String email) async {
    if (_codeController.text.isEmpty) {
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
      await auth.verifierCode(email, _codeController.text);

      if (mounted) Navigator.pushReplacementNamed(context, '/reset-password');
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
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
                    "Code de vérification",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInputField(
                    label: "Entrez le code",
                    controller: _codeController,
                    icon: Icons.code,
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
                    onPressed: _isLoading ? null : () => _handleSubmit(email),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Valider le code',
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
  }) {
    return TextField(
      controller: controller,
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
