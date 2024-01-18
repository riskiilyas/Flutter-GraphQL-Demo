import '../graphql.dart';

class DeleteNoteSchema extends QuerySchema {
  static const _query = """
      mutation DeleteNote(\$id: ID!) {
        deleteNote(id: \$id) {
          id
          title
          content
          author
        }
      }
    """;

  DeleteNoteSchema({required String id})
      : super(
            query: _query,
            variables: {
              'id': id,
            },
            cleanJson: (_) => _['deleteNote']);
}
