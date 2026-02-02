import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetail(this.note, this.appBarTitle, {Key? key}) : super(key: key);

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  static const _priorities = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper();

  String dropDownStringItem = 'Low';
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    dropDownStringItem = getPriorityAsString(widget.note.priority);
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    selectedColorIndex = widget.note.color;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        moveToLastScreen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
          backgroundColor: colors[selectedColorIndex],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: Theme.of(context).textTheme.titleMedium,
                  value: dropDownStringItem,
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      dropDownStringItem = valueSelectedByUser!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style: Theme.of(context).textTheme.titleMedium,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: Theme.of(context).textTheme.titleMedium,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          foregroundColor: Theme.of(context).primaryColorLight,
                        ),
                        child: const Text('Save'),
                        onPressed: () {
                          setState(() {
                            _save();
                          });
                        },
                      ),
                    ),
                    Container(width: 5.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          foregroundColor: Theme.of(context).primaryColorLight,
                        ),
                        child: const Text('Delete'),
                        onPressed: () {
                          setState(() {
                            _delete();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> colors = [
    Colors.white,
    Colors.red.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.pink.shade100,
    Colors.teal.shade100,
    Colors.indigo.shade100,
  ];

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        widget.note.priority = 1;
        break;
      case 'Low':
        widget.note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority = '';
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    widget.note.title = titleController.text;
  }

  void updateDescription() {
    widget.note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();

    updatePriorityAsInt(dropDownStringItem);
    widget.note.color = selectedColorIndex;
    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (widget.note.id != null) {
      result = await helper.updateNote(widget.note);
    } else {
      result = await helper.insertNote(widget.note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (widget.note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    int result = await helper.deleteNote(widget.note.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occurred while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
