import 'dart:io';
import 'package:factor_mobile_app/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilUserPage extends StatefulWidget {
  const ProfilUserPage({super.key});

  @override
  State<ProfilUserPage> createState() => _ProfilUserPageState();
}

class _ProfilUserPageState extends State<ProfilUserPage> {
  final Color backgroundColor = const Color(0xFFfcfcfc);
  final Color inputFillColor = const Color(0xFFf2f0f0);
  final Color borderColor = const Color(0xFFc2c2c2);
  final Color greenAccent = const Color(0xFF4cceac);
  final Color textColor = const Color(0xFF141414);

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomCtrl;
  late TextEditingController prenomCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController rneCtrl;
  late TextEditingController montantDisponibleCtrl;
  late TextEditingController montantUtiliseCtrl;
  late TextEditingController montantAutoCtrl;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    nomCtrl = TextEditingController();
    prenomCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    rneCtrl = TextEditingController();
    montantDisponibleCtrl = TextEditingController();
    montantUtiliseCtrl = TextEditingController();
    montantAutoCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<AuthProvider>(context).user;
    if (user != null) {
      nomCtrl.text = user.lastName;
      prenomCtrl.text = user.firstName;
      emailCtrl.text = user.email;
      rneCtrl.text = user.rne;
      montantDisponibleCtrl.text = user.disponible.toString();
      montantUtiliseCtrl.text = user.utilise.toString();
      montantAutoCtrl.text = user.limiteAuto.toString();
    }
  }

  @override
  void dispose() {
    nomCtrl.dispose();
    prenomCtrl.dispose();
    emailCtrl.dispose();
    rneCtrl.dispose();
    montantDisponibleCtrl.dispose();
    montantUtiliseCtrl.dispose();
    montantAutoCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _enregistrerProfil() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.updateUserProfile(
        firstName: prenomCtrl.text,
        lastName: nomCtrl.text,
        email: emailCtrl.text,
        profileImage: _selectedImage,
        token: authProvider.user!.token,
      );

      if (authProvider.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil enregistré avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : NetworkImage(
                          user?.profilePicture != null
                              ? 'http://10.0.2.2:8082/factoring/users/uploads/${user!.profilePicture}'
                              : 'https://i.pravatar.cc/150?img=3',
                        ) as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildEditableField("Nom", nomCtrl),
              const SizedBox(height: 16),
              _buildEditableField("Prénom", prenomCtrl),
              const SizedBox(height: 16),
              _buildEditableField("Email", emailCtrl,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildEditableField("RNE", rneCtrl, enabled: false),
              const SizedBox(height: 16),
              _buildEditableField("Montant Autorisé", montantAutoCtrl,
                  keyboardType: TextInputType.number, enabled: false),
              const SizedBox(height: 16),
              _buildEditableField("Montant Disponible", montantDisponibleCtrl,
                  keyboardType: TextInputType.number, enabled: false),
              const SizedBox(height: 16),
              _buildEditableField("Montant Utilisé", montantUtiliseCtrl,
                  keyboardType: TextInputType.number, enabled: false),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enregistrerProfil,
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenAccent,
                ),
                child: const Text(
                  'Enregistrer',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
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
          keyboardType: keyboardType,
          enabled: enabled,
          style: TextStyle(color: enabled ? textColor : Colors.grey[600]),
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
          ),
          validator: (value) {
            if (enabled && (value == null || value.isEmpty)) {
              return 'Ce champ est requis';
            }
            return null;
          },
        ),
      ],
    );
  }
}
