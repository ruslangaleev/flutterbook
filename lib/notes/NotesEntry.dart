import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";

import "NotesDBWorker.dart";
import "NotesModel.dart" show NotesModel, notesModel;

class NotesEntry extends StatelessWidget {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesEntry() {
    _titleEditingController.addListener(() {
      notesModel.entityBeingEdited.title = _titleEditingController.text;
    });

    _contentEditingController.addListener(() {
      notesModel.entityBeingEdited.content = _contentEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (notesModel.entityBeingEdited != null) {
      _titleEditingController.text = notesModel.entityBeingEdited.title;
      _contentEditingController.text = notesModel.entityBeingEdited.content;
    }

    return ScopedModel(
        model: notesModel,
        child: ScopedModelDescendant<NotesModel>(
          builder: (BuildContext inContext, Widget inChild, NotesModel inModel) {
            return Scaffold(
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  children: [
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        FocusScope.of(inContext).requestFocus(FocusNode());
                        inModel.setStackIndex(0);
                      }
                    ),
                    Spacer(),
                    FlatButton(
                      child: Text("Save"),
                      onPressed: () {
                        _save(inContext, notesModel);
                      }
                    )
                  ],
                ),
              ),
              body: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.title),
                      title: TextFormField(
                        decoration: InputDecoration(hintText: "Title"),
                        controller: _titleEditingController,
                        validator: (String? inValue) {
                          if (inValue != null) {
                            if (inValue.length == 0) {
                              return "Please enter a title";
                            }
                          }
                          return null;
                        }
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.content_paste),
                      title: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        decoration: InputDecoration(hintText: "Content"),
                        controller: _contentEditingController,
                        validator: (String? inValue) {
                          if (inValue != null) {
                            if (inValue.length == 0) {
                              return "Please enter content";
                            }
                          }
                          return null;
                        }
                      )
                    ),
                    ListTile(
                      leading: Icon(Icons.color_lens),
                      title: Row(
                        children: [
                          GestureDetector(
                            child: Container(
                              decoration: ShapeDecoration(
                                shape: Border.all(width: 18, color: Colors.red) +
                                  Border.all(width: 6, color: notesModel.color == "red" ? Colors.red : Theme.of(inContext).canvasColor)
                              ),
                            ),
                            onTap: () {
                              notesModel.entityBeingEdited.color = "red";
                              notesModel.setColor("red");
                            }
                          ),
                          Spacer()
                          // и так для каждого цвета...
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        )
    );
  }

  void _save(BuildContext inContext, NotesModel inModel) async {
    var currentState = _formKey.currentState;
    if (currentState == null) {
      return;
    }
    if (!currentState.validate()) {
      return;
    }
    if (inModel.entityBeingEdited.id == -1) {
      await NotesDBWorker.db.create(notesModel.entityBeingEdited);
    } else {
      await NotesDBWorker.db.update(notesModel.entityBeingEdited);
    }
    notesModel.loadData("notes", NotesDBWorker.db);

    inModel.setStackIndex(0);
    Scaffold.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Note saved")
      )
    );
  }
}