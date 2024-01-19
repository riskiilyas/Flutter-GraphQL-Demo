import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_demo/graphql.dart';
import 'package:graphql_demo/model/note_change.dart';
import 'package:graphql_demo/schema/create_note_schema.dart';
import 'package:graphql_demo/schema/delete_note_schema.dart';
import 'package:graphql_demo/schema/get_all_notes_schema.dart';
import 'package:graphql_demo/schema/note_subscription_schema.dart';
import 'package:graphql_demo/schema/update_note_schema.dart';

import 'model/note.dart';

enum NoteStatus { updated, created, deleted, none }

class NoteProvider extends ChangeNotifier {
  final List<Note> notes = [];
  final GraphQLService graphQLService;
  NoteStatus noteStatus = NoteStatus.none;
  late Stream<dynamic> noteSubscription;

  NoteProvider({required this.graphQLService}) {
    _init();
  }

  _init() async {
    try {
      noteSubscription =
          graphQLService.subscribe(schema: NoteSubscriptionSchema());

      noteSubscription.listen((event) {
        try {
          final noteChange = NoteChange.fromJson(event);
          noteStatus = switch (noteChange.status) {
            'ADDED' => NoteStatus.created,
            'UPDATED' => NoteStatus.updated,
            'DELETED' => NoteStatus.deleted,
            _ => NoteStatus.none
          };

          final newNote = noteChange.note;
          if (noteStatus == NoteStatus.created) {
            notes.add(newNote);
          } else if (noteStatus == NoteStatus.updated) {
            final i = notes.indexWhere((_) => _.id == newNote.id);
            notes[i] = Note(
                id: newNote.id,
                title: newNote.title,
                content: newNote.content,
                author: newNote.author);
          } else if (noteStatus == NoteStatus.deleted) {
            final i = notes.indexWhere((_) => _.id == newNote.id);
            notes.removeAt(i);
          }

          notifyListeners();
        } finally {}
      });

      final response = await graphQLService.query(schema: GetAllNotesSchema());
      for (var note in response) {
        notes.add(Note.fromJson(note));
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  addNote(
          {required String title,
          required String content,
          required String author}) =>
      graphQLService.mutate(
          schema:
              CreateNoteSchema(title: title, content: content, author: author));

  editNote(
          {required String id,
          required String title,
          required String content,
          required String author}) =>
      graphQLService.mutate(
          schema: UpdateNoteSchema(
              id: id, title: title, content: content, author: author));

  deleteNote({required String id}) =>
      graphQLService.mutate(schema: DeleteNoteSchema(id: id));
}
