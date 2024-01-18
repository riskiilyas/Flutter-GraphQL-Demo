import '../graphql.dart';

class UpdateNoteSchema extends QuerySchema {
  static const _query = """
    mutation UpdateNote(\$id: ID!, \$title: String, \$content: String, 
    \$author: String) {
      updateNote(id: \$id, title: \$title, content: \$content, author: \$author) {
        id
        title
        content
        author
      }
    }
    """;

  UpdateNoteSchema(
      {required String id, String? title, String? content, String? author})
      : super(
            query: _query,
            variables: {
              'id': id,
              'title': title,
              'content': content,
              'author': author
            },
            cleanJson: (_) => _['updateNote']);
}
