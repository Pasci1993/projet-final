import 'package:projet_final/notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialise la BDD
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'projet_final.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Création de la table utilisateurs
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        email TEXT NOT NULL,
        mdp TEXT NOT NULL
      )
    ''');

    await db.execute('''
CREATE TABLE notes (
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT NOT NULL,
content TEXT,
color TEXT,
dateTime TEXT,
utilisateur_id INTEGER,
FOREIGN KEY(utilisateur_id) REFERENCES utilisateurs(id)
)
''');
  }

  // Insertion d'un utilisateur
  Future<void> insertUser(String nom, String email, String mdp) async {
    final db = await database;
    await db.insert('utilisateurs', {
      'nom': nom,
      'email': email,
      'mdp': mdp,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Récupération d'un utilisateur par nom et mot de passe
  Future<Map<String, dynamic>?> getUser(String nom, String mdp) async {
    final db = await database;
    final result = await db.query(
      'utilisateurs',
      where: 'nom = ? AND mdp = ?',
      whereArgs: [nom, mdp],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Récupération d'un utilisateur par nom (pour vérifier l'existence)
  Future<Map<String, dynamic>?> getUserByName(String nom) async {
    final db = await database;
    final result = await db.query(
      'utilisateurs',
      where: 'nom = ?',
      whereArgs: [nom],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Note>> getNotesParUtilisateur(int utilisateurId) async {
    final db = await database;
    final res = await db.query(
      'notes',
      where: 'utilisateur_id = ?',
      whereArgs: [utilisateurId],
      orderBy: 'id DESC',
    );
    return res.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> addNote(Note note, int utilisateurId) async {
    final db = await database;
    return db.insert('notes', note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
