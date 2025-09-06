class Note {
  final int? id;
  final String title;
  final String content;
  final String color;
  final String dateTime;
  final int utilisateurId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
    required this.utilisateurId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
      'utilisateur_id': utilisateurId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as String,
      dateTime: map['dateTime'] as String,
      utilisateurId: map['utilisateur_id'] as int,
    );
  }
}
