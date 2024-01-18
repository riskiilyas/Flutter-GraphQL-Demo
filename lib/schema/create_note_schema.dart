import '../graphql.dart';

class CreateNoteSchema extends QuerySchema {
  static const _query = """
    mutation CreateNote(\$title: String!, \$content: String!, \$author: String!) {
      createNote(
        title: \$title
        content: \$content
        author: \$author
      ) {
        id
        title
        content
        author
      }
    }
    """;

  CreateNoteSchema(
      {required String title, required String content, required String author})
      : super(
            query: _query,
            variables: {'title': title, 'content': content, 'author': author},
            cleanJson: (_) => _['createNote']);
}
