import 'package:flutter/material.dart';
import 'package:projet_final/pages/database_helper.dart';
import 'package:projet_final/pages/page_connexion.dart';

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  State<PageInscription> createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmationMotDePasseController =
      TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _inscrireUtilisateur() async {
    final nom = _nomController.text.trim();
    final email = _emailController.text.trim();
    final mdp = _motDePasseController.text.trim();

    // Vérifier si l'utilisateur existe déjà
    final existingUser = await _dbHelper.getUserByName(nom);
    if (existingUser != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ce nom est déjà utilisé.")));
      return;
    }

    await _dbHelper.insertUser(nom, email, mdp);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Inscription réussie"),
        content: Text("Bienvenue, $nom !"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PageConnexion()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Créer un compte",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Champ Nom
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: "Nom",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Entrez votre nom' : null,
              ),
              const SizedBox(height: 20),

              // Champ Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez votre email';
                  } else if (!value.contains('@')) {
                    return 'Entrez un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Mot de passe
              TextFormField(
                controller: _motDePasseController,
                decoration: const InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Le mot de passe doit contenir au moins 6 caractères'
                    : null,
              ),
              const SizedBox(height: 20),

              // Confirmation mot de passe
              TextFormField(
                controller: _confirmationMotDePasseController,
                decoration: const InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer le mot de passe';
                  } else if (value != _motDePasseController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Bouton S'inscrire
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _inscrireUtilisateur();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
