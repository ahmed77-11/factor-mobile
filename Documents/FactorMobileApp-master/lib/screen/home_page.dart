import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:factor_mobile_app/providers/notification_provider.dart';
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

  final List<Widget> _pages = [
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
    // Disconnect notifications first
    Provider.of<NotificationProvider>(context, listen: false)
        .disconnectWebSocket();

    // Then logout
    await Provider.of<AuthProvider>(context, listen: false).logout();

    // Navigate to login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _handleRefresh() async {
    // You can add actual refresh logic here if needed
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final unreadCount = Provider.of<NotificationProvider>(context).unreadCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(_selectedIndex),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: greenAccent,
        foregroundColor: white,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NotificationPage(
                      userId: user!.email,
                      token: user.token,
                    ),
                  ),
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            color: white,
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _pages[_selectedIndex],
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
