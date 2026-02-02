import '../models/note.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static List<Note> _notes = [];
  static int _nextId = 1;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<List<Note>> getNoteList() async {
    return _notes;
  }

  Future<int> insertNote(Note note) async {
    note.id = _nextId++;
    _notes.add(note);
    return note.id!;
  }

  Future<int> updateNote(Note note) async {
    int index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      return 1;
    }
    return 0;
  }

  Future<int> deleteNote(int id) async {
    int index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes.removeAt(index);
      return 1;
    }
    return 0;
  }

  Future<int?> getCount() async {
    return _notes.length;
  }
}
