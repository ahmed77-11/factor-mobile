import 'package:factor_mobile_app/entities/contrat.dart';
import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entities/DemandeFinancement.dart';
import '../entities/devise.dart';
import '../service/devise_service.dart';
import '../service/demande_financement_service.dart';

class AddDemFinPage extends StatefulWidget {
  const AddDemFinPage({super.key});

  @override
  State<AddDemFinPage> createState() => _AddDemFinPageState();
}

class _AddDemFinPageState extends State<AddDemFinPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emisNoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _ribSuffixController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _libelleController = TextEditingController();
  final TextEditingController _infoLibreController = TextEditingController();

  final Color backgroundColor = const Color(0xFFfcfcfc);
  final Color inputFillColor = const Color(0xFFf2f0f0);
  final Color borderColor = const Color(0xFFc2c2c2);
  final Color greenAccent = const Color(0xFF4cceac);
  final Color textColor = const Color(0xFF141414);

  bool _isLoading = false;
  List<Devise> _devises = [];
  Devise? _selectedDevise;

  String? _selectedBankCode;
  final List<Map<String, String>> _banques = [
    {'code': '05', 'nom': 'Banque de Tunisie'},
    {'code': '10', 'nom': 'STB'},
    {'code': '08', 'nom': 'BIAT'},
    {'code': '07', 'nom': 'Amen Bank'},
    {'code': '11', 'nom': 'UBCI'},
  ];

  @override
  void initState() {
    super.initState();
    _loadDevises();
  }

  Future<void> _loadDevises() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final devises = await DeviseService().fetchDevise(auth.user!.token);
      setState(() {
        _devises = devises;
      });
    } catch (e) {
      print('Erreur lors du chargement des devises: $e');
    }
  }

  String get fullRib => (_selectedBankCode ?? '') + _ribSuffixController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Une Demande Du financement'),
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
                _buildInputField("Émission Numéro", _emisNoController),
                const SizedBox(height: 16),
                _buildDateInputField("Date d'Émission", _dateController),
                const SizedBox(height: 16),
                _buildBankSelection(),
                const SizedBox(height: 16),
                _buildRibField(),
                const SizedBox(height: 16),
                _buildInputField("Montant", _montantController),
                const SizedBox(height: 16),
                _buildDeviseDropdown(),
                const SizedBox(height: 16),
                _buildInputField("Libellé", _libelleController),
                const SizedBox(height: 16),
                _buildInputField("Info Libre", _infoLibreController),
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
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Soumettre la demande',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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

  Widget _buildInputField(String label, TextEditingController controller,
      {bool obscure = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(color: textColor),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Ce champ est requis";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: greenAccent, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: textColor),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Ce champ est requis";
            }
            return null;
          },
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
          onTap: _selectDate,
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        _dateController.text = '${selectedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  Widget _buildDeviseDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Devise",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Devise>(
          value: _selectedDevise,
          items: _devises.map((devise) {
            return DropdownMenuItem<Devise>(
              value: devise,
              child: Text(devise.dsg),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDevise = value;
            });
          },
          validator: (value) =>
              value == null ? 'Veuillez sélectionner une devise' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: inputFillColor,
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
      ],
    );
  }

  Widget _buildBankSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sélectionner la Banque",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedBankCode,
          hint: const Text("Banque"),
          items: _banques.map((bank) {
            return DropdownMenuItem<String>(
              value: bank['code'],
              child: Text(bank['nom']!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBankCode = value;
            });
          },
          validator: (value) =>
              value == null ? "Sélectionnez une banque" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: inputFillColor,
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
      ],
    );
  }

  Widget _buildRibField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("RIB Fin Adhérent",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _ribSuffixController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Suffixe RIB",
            filled: true,
            fillColor: inputFillColor,
            prefixText: _selectedBankCode ?? '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
          ),
          validator: (value) {
            if ((value == null || value.isEmpty) || _selectedBankCode == null) {
              return "RIB complet requis";
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final demande = DemandeFinancement(
        id: 0,
        numeroContrat: '', // Supplied elsewhere
        adherEmisNo: _emisNoController.text,
        adherEmisDate: _dateController.text,
        adherRib: fullRib,  
        adherMontant: double.tryParse(_montantController.text) ?? 0.0,
        devise: _selectedDevise!,
        adherLibelle: _libelleController.text,
        adherInfoLibre: _infoLibreController.text,
        contrat: Contrat(
          id: auth.user!.contratId,
          contratNo: "",
        ),
      );

      final success = await DemandeFinancementService().envoyerDemande(
        demande,
        auth.user!.token,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demande envoyée avec succès.')),
        );
        _formKey.currentState?.reset();
        setState(() {
          _selectedDevise = null;
          _selectedBankCode = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Echec de l\'envoi. Veuillez réessayer.')),
        );
      }
    }
  }
}
