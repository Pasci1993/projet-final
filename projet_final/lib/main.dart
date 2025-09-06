import 'package:flutter/material.dart';
import 'package:projet_final/pages/interface_appli.dart';

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const InterfaceAppli(title: 'MesNotes'),
    );
  }
}
