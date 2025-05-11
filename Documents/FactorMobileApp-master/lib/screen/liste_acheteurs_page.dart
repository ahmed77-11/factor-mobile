import 'package:flutter/material.dart';
import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:factor_mobile_app/entities/acheteur_response.dart';
import 'package:factor_mobile_app/service/relations_service.dart';
import 'package:provider/provider.dart';

class ListeAcheteursPage extends StatefulWidget {
  const ListeAcheteursPage({super.key});

  @override
  State<ListeAcheteursPage> createState() => _ListeAcheteursPageState();
}

class _ListeAcheteursPageState extends State<ListeAcheteursPage> {
  late Future<List<AcheteurResponse>> _acheteursFuture;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = auth.user!.token;
    final userId = auth.user!.adherentId;
    _acheteursFuture = RelationsService().fetchAcheteurs(userId, token);
  }

  void _consulterAcheteur(AcheteurResponse acheteur) {
    Navigator.pushNamed(
      context,
      '/detail-acheteur',
      arguments: acheteur,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<AcheteurResponse>>(
          future: _acheteursFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucun acheteur trouvé.'));
            }

            final acheteurs = snapshot.data!;

            return ListView.builder(
              itemCount: acheteurs.length,
              itemBuilder: (context, index) {
                final a = acheteurs[index];
                final isPhysique = a.acheteurPhysique != null;
                final nomRaison = isPhysique
                    ? '${a.acheteurPhysique?.nom ?? ''} ${a.acheteurPhysique?.prenom ?? ''}'
                    : a.acheteurMorale?.raisonSocial ?? '';

                final pieceIdentite = isPhysique
                    ? '${a.acheteurPhysique?.typePieceIdentite?.dsg ?? ''} ${a.acheteurPhysique?.numeroPieceIdentite ?? ''}'
                    : '${a.acheteurMorale?.typePieceIdentite?.dsg ?? ''} ${a.acheteurMorale?.numeroPieceIdentite ?? ''}';

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF4cceac),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      nomRaison.trim(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      pieceIdentite.trim(),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () => _consulterAcheteur(a),
                      icon: const Icon(Icons.visibility),
                      label: const Text('Consulter'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF4cceac),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
