import 'package:factor_mobile_app/entities/contrat.dart';
import 'package:factor_mobile_app/entities/devise.dart';
import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entities/DemandeFinancement.dart';
import '../service/demande_financement_service.dart';

class EditDemFinPage extends StatefulWidget {
  const EditDemFinPage({super.key});

  @override
  State<EditDemFinPage> createState() => _EditDemFinPageState();
}

class _EditDemFinPageState extends State<EditDemFinPage> {
  final _formKey = GlobalKey<FormState>();

  final Color backgroundColor = const Color(0xFFfcfcfc);
  final Color inputFillColor = const Color(0xFFf2f0f0);
  final Color borderColor = const Color(0xFFc2c2c2);
  final Color greenAccent = const Color(0xFF4cceac);
  final Color textColor = const Color(0xFF141414);

  late DemandeFinancement demandeFin;

  late TextEditingController numeroContratCtrl;
  late TextEditingController emisNoCtrl;
  late TextEditingController emisDateCtrl;
  late TextEditingController ribCtrl;
  late TextEditingController montantCtrl;
  late TextEditingController deviseCtrl;
  late TextEditingController libelleCtrl;
  late TextEditingController infoLibreCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    demandeFin =
        ModalRoute.of(context)!.settings.arguments as DemandeFinancement;

    // numeroContratCtrl = TextEditingController(text: demandeFin.numeroContrat);
    emisNoCtrl = TextEditingController(text: demandeFin.adherEmisNo);
    emisDateCtrl = TextEditingController(text: demandeFin.adherEmisDate);
    ribCtrl = TextEditingController(text: demandeFin.adherRib);
    montantCtrl =
        TextEditingController(text: demandeFin.adherMontant.toString());
    deviseCtrl = TextEditingController(text: demandeFin.devise.dsg);
    libelleCtrl = TextEditingController(text: demandeFin.adherLibelle);
    infoLibreCtrl = TextEditingController(text: demandeFin.adherInfoLibre);
  }

  @override
  void dispose() {
    // numeroContratCtrl.dispose();
    emisNoCtrl.dispose();
    emisDateCtrl.dispose();
    ribCtrl.dispose();
    montantCtrl.dispose();
    deviseCtrl.dispose();
    libelleCtrl.dispose();
    infoLibreCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(emisDateCtrl.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        emisDateCtrl.text = '${selectedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _updateDemande() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = DemandeFinancement(
      id: demandeFin.id,
      numeroContrat: '',
      adherEmisNo: emisNoCtrl.text,
      adherEmisDate: emisDateCtrl.text,
      adherRib: ribCtrl.text,
      adherMontant: double.tryParse(montantCtrl.text) ?? 0,
      devise: demandeFin.devise,
      adherLibelle: libelleCtrl.text,
      adherInfoLibre: infoLibreCtrl.text,
      contrat: demandeFin.contrat,
    );

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      await DemandeFinancementService()
          .updateDemande(updated, auth.user!.token);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande modifiée avec succès')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isNumber = false, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (value) =>
              value == null || value.isEmpty ? 'Ce champ est requis' : null,
          enabled: enabled,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputFillColor,
            prefixIcon: const Icon(Icons.edit, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: greenAccent, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDateInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: _selectDate,
          validator: (value) =>
              value == null || value.isEmpty ? 'Ce champ est requis' : null,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: "YYYY-MM-DD",
            filled: true,
            fillColor: inputFillColor,
            prefixIcon: const Icon(Icons.calendar_today, color: Colors.black54),
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
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Une Demande Du financement'),
        backgroundColor: greenAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // _buildInputField("Numéro Contrat", numeroContratCtrl),
                _buildInputField("Émission Numéro", emisNoCtrl),
                _buildDateInputField("Date d'Émission", emisDateCtrl),
                _buildInputField("RIB Fin Adhérent", ribCtrl),
                _buildInputField("Montant", montantCtrl, isNumber: true),
                _buildInputField("Devise", deviseCtrl, enabled: false),
                _buildInputField("Libellé", libelleCtrl),
                _buildInputField("Info Libre", infoLibreCtrl),
                ElevatedButton(
                  onPressed: _updateDemande,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
