import 'package:factor_mobile_app/entities/acheteur_morale.dart';
import 'package:factor_mobile_app/entities/acheteur_physique.dart';
import 'package:flutter/material.dart';
import 'package:factor_mobile_app/entities/acheteur_response.dart';

class DetailAcheteurPage extends StatelessWidget {
  const DetailAcheteurPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! AcheteurResponse) {
      return const Scaffold(
        body: Center(
          child: Text('Aucun acheteur à afficher.'),
        ),
      );
    }

    final acheteur = args;
    final isPhysique = acheteur.acheteurPhysique != null;
    final info = isPhysique
        ? acheteur.acheteurPhysique!
        : acheteur
            .acheteurMorale!; // Now `info` is either AcheteurPhysique or AcheteurMorale

    final title = isPhysique
        ? '${(info as AcheteurPhysique).nom ?? ''} ${(info as AcheteurPhysique).prenom ?? ''}'
            .trim()
        : (info as AcheteurMorale).raisonSocial ?? 'Acheteur Moral';

    // Access typePieceIdentite only if it's AcheteurMorale, avoid casting twice
    final typePiece = isPhysique
        ? (info as AcheteurPhysique).typePieceIdentite?.dsg ?? 'Non défini'
        : (info as AcheteurMorale).typePieceIdentite?.dsg ?? 'Non défini';
    final numeroPiece = isPhysique
        ? (info as AcheteurPhysique).numeroPieceIdentite ?? 'Non défini'
        : (info as AcheteurMorale).numeroPieceIdentite ?? 'Non défini';
    final adresse = isPhysique
        ? (info as AcheteurPhysique).adresse ?? 'Non défini'
        : (info as AcheteurMorale).adresse ?? 'Non défini';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Acheteur'),
        backgroundColor: const Color(0xFF4cceac),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.person,
                    size: 72,
                    color: const Color(0xFF4cceac),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // General Information
                _buildInfoRow('ID Acheteur', acheteur.id.toString()),
                _buildInfoRow('Type de pièce', typePiece),
                _buildInfoRow('Numéro de pièce', numeroPiece),
                _buildInfoRow('Adresse', adresse),

                const Divider(height: 32, thickness: 1),

                // Specific Info for Acheteur Physique or Morale
                if (isPhysique) ...[
                  _buildInfoRow(
                      'Nom', (info as AcheteurPhysique).nom ?? 'Non précisé'),
                  _buildInfoRow('Prénom',
                      (info as AcheteurPhysique).prenom ?? 'Non précisé'),
                ] else ...[
                  _buildInfoRow('Raison Sociale',
                      (info as AcheteurMorale).raisonSocial ?? 'Non précisée'),
                ],

                const Divider(height: 32, thickness: 1),

                // New Fields from API Response
                _buildInfoRow('Délai Max Paiement',
                    acheteur.delaiMaxPai?.toString() ?? 'Non précisé'),
                _buildInfoRow('Limite d\'Achat',
                    acheteur.limiteAchat?.toString() ?? 'Non précisé'),
                _buildInfoRow('Reste d\'Achat',
                    acheteur.resteAchat?.toString() ?? 'Non précisé'),
                _buildInfoRow('Limite de Couverture',
                    acheteur.limiteCouverture?.toString() ?? 'Non précisé'),
                _buildInfoRow('Comité Risque',
                    acheteur.comiteRisqueTexte ?? 'Non précisé'),
                _buildInfoRow('Comité Dérogation',
                    acheteur.comiteDerogTexte ?? 'Non précisé'),
                _buildInfoRow('Date d\'Effet',
                    acheteur.effetDate?.toString() ?? 'Non précisé'),
                _buildInfoRow(
                    'Info Libre', acheteur.infoLibre ?? 'Non précisé'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
