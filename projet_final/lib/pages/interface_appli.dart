import 'package:flutter/material.dart';
import 'package:projet_final/pages/page_inscr.dart';

class InterfaceAppli extends StatefulWidget {
  const InterfaceAppli({super.key, required this.title});

  final String title;

  @override
  State<InterfaceAppli> createState() => _PageAccueil();
}

class _PageAccueil extends State<InterfaceAppli> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFF2196F3)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("📘", style: TextStyle(fontSize: 60)),
                    SizedBox(height: 20),
                    Text(
                      "MesNotes",
                      style: TextStyle(
                        fontFamily: 'Jaini',
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageInscription(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                    ),
                    child: const Text("Get start"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
