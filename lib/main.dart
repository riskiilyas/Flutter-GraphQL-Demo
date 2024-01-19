import 'package:flutter/material.dart';
import 'package:graphql_demo/home_screen.dart';
import 'package:provider/provider.dart';

import 'graphql.dart';
import 'graphql_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const url = 'http://YOUR_IP_ADDRESS:4000/graphql';
    GraphQLService graphQLService = GraphQLService(url: url);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => NoteProvider(graphQLService: graphQLService)),
      ],
      child: MaterialApp(
          title: 'GraphQL Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          home: const HomeScreen()),
    );
  }
}
