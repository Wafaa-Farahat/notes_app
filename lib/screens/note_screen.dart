import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/database_helper.dart';

class NoteScreen extends StatelessWidget {
  final Note? note;
  const NoteScreen({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    if (note != null) {
      titleController.text = note!.title;
      descriptionController.text = note!.description;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text(
          note == null ? 'Add a note' : 'Edit note',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.brown.shade50,
        height: 700,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 40),
                  // question
                  child: Center(
                    child: Text(
                      'What are you thinking about?',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // note title
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: titleController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      labelText: 'Note title',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                // note description
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: 'Type here the note',
                      labelText: 'Note description',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.75,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ))),
                  keyboardType: TextInputType.multiline,
                  onChanged: (str) {},
                  maxLines: 5,
                ),
                // const Spacer(),
                const SizedBox(
                  height: 20,
                ),
                // save button
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                        // save button
                    child: ElevatedButton(
                      onPressed: () async {
                        final title = titleController.value.text;
                        final description = descriptionController.value.text;

                        if (title.isEmpty || description.isEmpty) {
                        // no code will be executed here
                          return;
                        }
                        // Todo save or update note in the model
                        final Note model = Note(
                            title: title,
                            description: description,
                            id: note?.id);
                        // check the note so if not exist add it else update it
                        if (note == null) {
                          await DatabaseHelper.addNote(model);
                        } else {
                          await DatabaseHelper.updateNote(model);
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.brown[400]!),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                              width: 0.75,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        note == null ? 'Save' : 'Edit',
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
