import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:factor_mobile_app/screen/AddDemFinPage.dart';
import 'package:factor_mobile_app/screen/EditDemFinPage.dart';
import 'package:factor_mobile_app/screen/detail_acheteur_page.dart';
import 'package:factor_mobile_app/screen/home_page.dart';
import 'package:factor_mobile_app/screen/login.dart';
import 'package:factor_mobile_app/screen/receive_code.dart';
import 'package:factor_mobile_app/screen/reset_password.dart';
import 'package:factor_mobile_app/screen/reset_password_ft.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for AuthProvider to finish loading user data before running the app
  final authProvider = AuthProvider();
  await authProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Financement',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.user == null) {
                  return const LoginPage();
                } else if (auth.user!.forceChangePassword == true) {
                  // Redirect to first-time password reset screen
                  Future.microtask(() {
                    Navigator.pushReplacementNamed(
                      context,
                      '/change-password-first-time',
                    );
                  });
                  return const SizedBox(); // Temporary empty widget
                } else {
                  return const HomePage();
                }
              },
            ),
        '/change-password-first-time': (context) => const ResetPasswordFT(),
        '/verif-code': (context) => const ReceiveCodePage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/login': (context) => const LoginPage(),
        '/detail-acheteur': (context) => const DetailAcheteurPage(),
        '/ajouter-demfin': (context) => const AddDemFinPage(),
        '/edit-demfin': (context) => EditDemFinPage(),
      },
    );
  }
}
