class Note {
  int? _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  int _color;

  Note(this._title, this._date, this._priority, this._color, [this._description = '']);

  Note.withId(this._id, this._title, this._date, this._priority, this._color, [this._description = '']);

  int? get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  int get color => _color;
  String get date => _date;

  set id(int? newId) => _id = newId;
  set title(String newTitle) => _title = newTitle;
  set description(String newDescription) => _description = newDescription;
  set priority(int newPriority) => _priority = newPriority;
  set color(int newColor) => _color = newColor;
  set date(String newDate) => _date = newDate;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['color'] = _color;
    map['date'] = _date;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map)
      : _id = map['id'],
        _title = map['title'],
        _description = map['description'],
        _priority = map['priority'],
        _color = map['color'],
        _date = map['date'];
}
