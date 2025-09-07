import 'package:flutter/material.dart';
import 'package:projet_final/pages/add_edit_screen.dart';
import 'package:projet_final/pages/view_note_sceen.dart';
import '../notes_model.dart';
import 'database_helper.dart';

class PageNotesScreen extends StatefulWidget {
  final int utilisateurId;
  final String nomUtilisateur;

  const PageNotesScreen({
    super.key,
    required this.utilisateurId,
    required this.nomUtilisateur,
    required mdpUtilisateur,
  });

  @override
  State<PageNotesScreen> createState() => _PageNotesScreenState();
}

class _PageNotesScreenState extends State<PageNotesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _dbHelper.getNotesParUtilisateur(widget.utilisateurId);
    setState(() => _notes = notes);
  }

  String _formatDateTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Aujourd\'hui, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes de ${widget.nomUtilisateur}"),
        backgroundColor: Colors.blue,
      ),
      body: _notes.isEmpty
          ? const Center(child: Text("Aucune note disponible."))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return GestureDetector(
                  onTap: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewNoteScreen(note: note),
                      ),
                    );
                    if (updated == true) _loadNotes();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(int.parse(note.color)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            note.content,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDateTime(note.dateTime),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF50C878),
        child: const Icon(Icons.add),
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddEditNoteScreen(utilisateurId: widget.utilisateurId),
            ),
          );
          if (created == true) _loadNotes();
        },
      ),
    );
  }
}
