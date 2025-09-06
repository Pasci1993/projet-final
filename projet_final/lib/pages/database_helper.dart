import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../notes_model.dart';

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

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mes_notes.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL UNIQUE,
        mot_de_passe TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        color TEXT,
        dateTime TEXT,
        utilisateur_id INTEGER,
        FOREIGN KEY(utilisateur_id) REFERENCES utilisateurs(id)
      )
    ''');
  }

  Future<bool> isUserExists(String nom) async {
    final db = await database;
    final res = await db.query(
      'utilisateurs',
      where: 'nom = ?',
      whereArgs: [nom],
    );
    return res.isNotEmpty;
  }

  Future<int> insertUser(String nom, String motDePasse) async {
    final db = await database;
    return db.insert('utilisateurs', {
      'nom': nom,
      'mot_de_passe': motDePasse,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser(String nom, String motDePasse) async {
    final db = await database;
    final res = await db.query(
      'utilisateurs',
      where: 'nom = ? AND mot_de_passe = ?',
      whereArgs: [nom, motDePasse],
    );
    return res.isNotEmpty ? res.first : null;
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
