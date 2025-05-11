import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:factor_mobile_app/screen/ListeDemFinPage.dart';
import 'package:factor_mobile_app/screen/liste_acheteurs_page.dart';
import 'package:factor_mobile_app/screen/main_screen.dart';
import 'package:factor_mobile_app/screen/profil_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'NotificationsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final Color greenAccent = const Color.fromRGBO(76, 206, 172, 1);
  final Color white = const Color.fromARGB(255, 240, 240, 240);

  static final List<Widget> _pages = [
    const MainScreen(),
    const ListeAcheteursPage(),
    const ListeDemFinPage(),
    const ProfilUserPage(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() => _selectedIndex = index);
    }
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'App Financement';
      case 1:
        return 'Liste des Acheteurs';
      case 2:
        return 'Demandes de Financement';
      case 3:
        return 'Profil Utilisateur';
      default:
        return 'App Financement';
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(_selectedIndex),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: greenAccent,
        foregroundColor: white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            color: white,
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Acheteurs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Demandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: greenAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
