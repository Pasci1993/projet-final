import 'package:flutter/material.dart';
import 'database_helper.dart';

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  State<PageInscription> createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _mdpController = TextEditingController();
  final _db = DatabaseHelper();

  bool _obscureText = true;

  @override
  void dispose() {
    _nomController.dispose();
    _mdpController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final nom = _nomController.text.trim();
      final mdp = _mdpController.text;

      if (await _db.isUserExists(nom)) {
        _showDialog("Erreur", "Nom d'utilisateur déjà utilisé");
      } else {
        await _db.insertUser(nom, mdp);
        _showDialog("Succès", "Inscription réussie !", success: true);
      }
    }
  }

  void _showDialog(String title, String content, {bool success = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Inscription")),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Entrez un nom" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _mdpController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Entrez un mot de passe" : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _register,
              child: const Text("S'inscrire"),
            ),
          ],
        ),
      ),
    ),
  );
}
