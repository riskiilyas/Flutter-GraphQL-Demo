import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_demo/graphql.dart';
import 'package:graphql_demo/model/note.dart';
import 'package:graphql_demo/schema/create_note_schema.dart';
import 'package:graphql_demo/schema/delete_note_schema.dart';
import 'package:graphql_demo/schema/get_all_notes_schema.dart';
import 'package:graphql_demo/schema/note_subscription_schema.dart';
import 'package:graphql_demo/schema/update_note_schema.dart';

void main() {
  const url = 'http://localhost:4000/graphql';
  String myTitle = 'Boring Day';
  String myContent = 'What a boring day programming flutter app!';
  const myself = 'John Doe';
  late String myNoteId;
  GraphQLService graphQLService = GraphQLService(url: url);
  late Stream<dynamic> subscription;
  final emittedStatus = [];

  setUpAll(() async {
    final schema = NoteSubscriptionSchema();
    subscription = graphQLService.subscribe(schema: schema);
    subscription.listen((event) {
      print(event);
      emittedStatus.add(event['status'].toString());
    });

    // Make Sure Websocket Successfully Connected
    await Future.delayed(const Duration(seconds: 3));
  });

  test('Create Note Test', () async {
    try {
      final schema =
          CreateNoteSchema(title: myTitle, content: myContent, author: myself);

      final response = await graphQLService.mutate(schema: schema);

      final note = Note.fromJson(response);
      expect(note.title, equals(myTitle));
      expect(note.content, equals(myContent));
      expect(note.author, equals(myself));
      expect(int.parse(note.id), greaterThan(0));
      myNoteId = note.id;
    } catch (e) {
      rethrow;
    }
  });

  test('Get All Notes Test', () async {
    try {
      final schema = GetAllNotesSchema();
      final response = await graphQLService.query(schema: schema);

      List<Note> notes = [];
      for (var note in response) {
        notes.add(Note.fromJson(note));
      }

      bool hasMyNote = notes.where((_) => _.id == myNoteId).isNotEmpty;
      expect(hasMyNote, isTrue);
    } catch (e) {
      rethrow;
    }
  });

  test('Update Note Test', () async {
    try {
      myTitle = 'My Edited Note';

      final schema = UpdateNoteSchema(id: myNoteId, title: myTitle);

      final response = await graphQLService.mutate(schema: schema);

      final note = Note.fromJson(response);
      expect(note.title, equals(myTitle));
      expect(note.content, equals(myContent));
      expect(note.author, equals(myself));
      expect(note.id, equals(myNoteId));
    } catch (e) {
      rethrow;
    }
  });

  test('Delete Note Test', () async {
    try {
      final schema = DeleteNoteSchema(id: myNoteId);

      final response = await graphQLService.mutate(schema: schema);

      final note = Note.fromJson(response);
      expect(note.title, equals(myTitle));
      expect(note.content, equals(myContent));
      expect(note.author, equals(myself));
      expect(note.id, equals(myNoteId));
    } catch (e) {
      rethrow;
    }
  });

  test('Subscription Result Test ', () {
    try {
      final statusList = ['ADDED', 'UPDATED', 'DELETED'];

      expect(emittedStatus[0], equals(statusList[0]));
      expect(emittedStatus[1], equals(statusList[1]));
      expect(emittedStatus[2], equals(statusList[2]));
      expect(emittedStatus.length, equals(3));
    } catch (e) {
      rethrow;
    }
  });
}
