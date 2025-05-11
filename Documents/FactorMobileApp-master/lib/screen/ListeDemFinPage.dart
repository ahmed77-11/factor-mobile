import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entities/DemandeFinancement.dart';
import '../providers/AuthProvider.dart';
import '../service/demande_financement_service.dart';

class ListeDemFinPage extends StatefulWidget {
  const ListeDemFinPage({Key? key}) : super(key: key);

  @override
  _ListeDemFinPageState createState() => _ListeDemFinPageState();
}

class _ListeDemFinPageState extends State<ListeDemFinPage> {
  late Future<List<DemandeFinancement>> _demandesFuture;
  final _theme = _AppTheme();

  @override
  void initState() {
    super.initState();
    _loadDemandes();
  }

  void _loadDemandes() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _demandesFuture = DemandeFinancementService().fetchAllDemandes(
      auth.user!.contratId,
      auth.user!.token,
    );
  }

  Future<void> _delete(int id) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      await DemandeFinancementService().deleteDemande(
        id,
        auth.user!.token,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande $id supprimée')),
      );
      setState(_loadDemandes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Supprimer cette demande ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Annuler')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _delete(id);
            },
            child: Text('Supprimer', style: TextStyle(color: _theme.danger)),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateAndRefresh(String route, {Object? args}) async {
    await Navigator.pushNamed(context, route, arguments: args);
    setState(_loadDemandes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/ajouter-demfin'),
        icon: Icon(Icons.add),
        label: Text('Nouvelle demande'),
        backgroundColor: _theme.accent,
        foregroundColor: _theme.background,
      ),
      body: FutureBuilder<List<DemandeFinancement>>(
        future: _demandesFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Erreur: ${snap.error}'));
          } else if (snap.data == null || snap.data!.isEmpty) {
            return Center(child: Text('Aucune demande.'));
          }
          final list = snap.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final d = list[i];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: _theme.accent.withOpacity(0.2),
                    child: Icon(Icons.request_page, color: _theme.accent),
                  ),
                  title: Text('Émission N° ${d.adherEmisNo}',
                      style: _theme.itemTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text('RIB: ${d.adherRib}', style: _theme.itemText),
                      SizedBox(height: 2),
                      Text('Date: ${d.adherEmisDate}', style: _theme.itemText),
                      SizedBox(height: 2),
                      Text(
                          'Montant: ${d.adherMontant.toStringAsFixed(2)} ${d.devise.dsg}',
                          style: _theme.itemHighlight),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'edit') {
                        _navigateAndRefresh('/edit-demfin', args: d);
                      } else if (val == 'delete') {
                        _confirmDelete(d.id);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'edit', child: Text('Modifier')),
                      PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Centralized theme styles
class _AppTheme {
  final Color background = Color(0xFFfcfcfc);
  final Color accent = Color(0xFF4cceac);
  final Color text = Color(0xFF141414);
  final Color danger = Colors.red;
  final TextStyle title = TextStyle(
      color: Color(0xFF141414), fontSize: 20, fontWeight: FontWeight.bold);
  final TextStyle itemTitle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF141414));
  final TextStyle itemText =
      TextStyle(fontSize: 14, color: Color(0xFF141414).withOpacity(0.7));
  final TextStyle itemHighlight = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF4cceac));
}
