import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:factor_mobile_app/providers/AuthProvider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // Color palette
  final Color backgroundColor = const Color(0xFFfcfcfc);
  final Color inputFillColor = const Color(0xFFf2f0f0);
  final Color borderColor = const Color(0xFFc2c2c2);
  final Color greenAccent = const Color(0xFF4cceac);
  final Color textColor = const Color(0xFF141414);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Text(
                  user != null
                      ? 'Bienvenue Dans Med-Factor, ${user.firstName}'
                      : 'Bienvenue!',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: inputFillColor,
                  backgroundImage: const AssetImage('assets/logoMf.jpg'),
                ),
                const SizedBox(height: 24),

                // Welcome Text

                // Subheading
                Text(
                  'Votre aperçu financier',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),

                // Financial Info Card
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: borderColor),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildDataRow('Limite autorisée', user?.limiteAuto ?? 0,
                            greenAccent),
                        Divider(color: borderColor),
                        _buildDataRow(
                            'Disponible', user?.disponible ?? 0, greenAccent),
                        Divider(color: borderColor),
                        _buildDataRow(
                            'Utilisé', user?.utilise ?? 0, Colors.redAccent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, double value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} TND',
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
