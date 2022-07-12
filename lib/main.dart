import "package:flutter/material.dart";
import 'home_screen.dart';
import "package:graphql_flutter/graphql_flutter.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink link = HttpLink("http://192.168.56.1:3000/graphql");

    ValueNotifier<GraphQLClient> client =
        ValueNotifier(GraphQLClient(cache: GraphQLCache(), link: link)
        );

    return GraphQLProvider(
        client: client,
        child: MaterialApp(
          home: HomeScreen(),
        ));
  }
}