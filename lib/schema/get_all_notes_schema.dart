import 'package:graphql_demo/graphql.dart';

class GetAllNotesSchema extends QuerySchema {
  static const _query = """
    query Notes {
        notes {
            id
            title
            content
            author
        }
    }
  """;

  GetAllNotesSchema()
      : super(query: _query, variables: {}, cleanJson: (_) => _['notes']);
}
