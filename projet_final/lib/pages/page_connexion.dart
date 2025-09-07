import 'package:flutter/material.dart';
import 'package:projet_final/pages/home_screen.dart';
import 'database_helper.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({super.key});

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final nom = _nomController.text.trim();
      final mdp = _mdpController.text;
      final user = await _db.getUser(nom, mdp);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PageNotesScreen(
              utilisateurId: user['id'],
              nomUtilisateur: user['nom'],
              mdpUtilisateur: user['mdp'],
            ),
          ),
        );
      } else {
        _showDialog("Erreur", "Nom d'utilisateur ou mot de passe incorrect");
      }
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Connexion")),
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
              onPressed: _login,
              child: const Text("Se connecter"),
            ),
          ],
        ),
      ),
    ),
  );
}
