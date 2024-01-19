import 'package:graphql_flutter/graphql_flutter.dart';

// This Would Be Useful With StateManagement
class GraphQLService {
  GraphQLClient? _client;
  final String url;
  final String? token;
  final GraphQLCache? cache;

  GraphQLService({required this.url, this.token, this.cache});

  Future<dynamic> query({required QuerySchema schema, String? token}) async {
    _handleClient(token);

    final response = await _client!.query(
        QueryOptions(document: gql(schema.query), variables: schema.variables));

    if (response.hasException) throw response.exception!;

    return schema.cleanJson(response.data!);
  }

  Future<dynamic> mutate({required QuerySchema schema, String? token}) async {
    _handleClient(token);

    final response = await _client!.mutate(MutationOptions(
        document: gql(schema.query), variables: schema.variables));

    if (response.hasException) throw response.exception!;

    return schema.cleanJson(response.data!);
  }

  Stream<dynamic> subscribe({required QuerySchema schema}) {
    final wsUrl = 'ws${url.split('http')[1]}';
    final wsLink =
        WebSocketLink(wsUrl, subProtocol: GraphQLProtocol.graphqlTransportWs);

    final wsClient = GraphQLClient(link: wsLink, cache: GraphQLCache());

    final response = wsClient.subscribe(SubscriptionOptions(
        document: gql(schema.query), variables: schema.variables));

    final mappedResponse = response.map((data) {
      if (data.hasException) throw data.exception!;
      return schema.cleanJson(data.data!);
    });

    return mappedResponse;
  }

  _handleClient(String? token) {
    if (token != null) {
      _client = GraphQLClient(
          link: AuthLink(getToken: () => token).concat(HttpLink(url)),
          cache: cache ?? GraphQLCache());
    }

    _client ??=
        GraphQLClient(link: HttpLink(url), cache: cache ?? GraphQLCache());
  }
}

abstract class QuerySchema {
  final String query;
  final Map<String, dynamic> variables;
  final dynamic Function(Map<String, dynamic>) cleanJson;

  QuerySchema(
      {required this.query, required this.variables, required this.cleanJson});
}
