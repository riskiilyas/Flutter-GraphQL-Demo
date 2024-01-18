import 'package:graphql_demo/graphql.dart';

class NoteSubscriptionSchema extends QuerySchema {
  static const _query = """
    subscription NoteChanged {
        noteChanged {
            status
            note {
                id
                title
                content
                author
            }
        }
    }
  """;

  NoteSubscriptionSchema()
      : super(query: _query, variables: {}, cleanJson: (_) => _['noteChanged']);
}
