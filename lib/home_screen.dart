import 'package:flutter/material.dart';
import 'package:graphql_demo/graphql_provider.dart';
import 'package:graphql_demo/model/note.dart';
import 'package:graphql_demo/widgets/note_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 32,
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Text(
              'GraphQL Demo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Consumer<NoteProvider>(builder: (context, provider, widget) {
          final notes = provider.notes;
          _showUpdateSnackbar(context, provider.noteStatus);

          return ListView.builder(
              itemCount: notes.length + 1,
              itemBuilder: (context, i) {
                if (i == notes.length) {
                  return const SizedBox(
                    height: 64,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: NoteItem(
                    note: notes[i],
                    onEdit: () => _showNoteDialog(context, note: notes[i]),
                    onDelete: () => provider.deleteNote(id: notes[i].id),
                  ),
                );
              });
        }),
      ),
    );
  }

  _showNoteDialog(BuildContext context, {Note? note}) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final TextEditingController authorController = TextEditingController();

    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
      authorController.text = note.author;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            note == null ? 'Add New Note' : 'Edit Note',
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          contentPadding: const EdgeInsets.all(16),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Add some space between fields
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: 6,
                ),
                const SizedBox(height: 10), // Add some space between fields
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final provider = context.read<NoteProvider>();
                if (note == null) {
                  provider.addNote(
                      title: titleController.text,
                      content: contentController.text,
                      author: authorController.text);
                } else {
                  provider.editNote(
                      id: note.id,
                      title: titleController.text,
                      content: contentController.text,
                      author: authorController.text);
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(note == null ? 'Submit' : 'Edit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // context.read<NoteProvider>();
  }

  void _showUpdateSnackbar(BuildContext context, NoteStatus noteStatus) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (noteStatus) {
        case NoteStatus.updated:
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('A Note Has Been Updated!')));
          break;
        case NoteStatus.created:
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('New Note Created!')));
          break;
        case NoteStatus.deleted:
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('A Note Has Been Deleted!')));
          break;
        case NoteStatus.none:
      }
    });
  }
}
