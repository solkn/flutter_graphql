import 'package:flutter/material.dart';
import 'package:flutter_graphql/addMovie_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:todo_graphql/UsersPage.dart';

class HomeScreen extends StatelessWidget {
  final String fetchMovies = """
    query {
      movies {
        _id
        title
        description
        director
       
      }
    }
  """;

  final String deleteMovie = """
    mutation deleteMovie(\$id: ID!) {
      action: deleteMovie(id: \$id) {
        id
        title
        description
        director
  
       
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.supervised_user_circle),
            onPressed: () {
              Navigator.pushReplacement(context,
                  //MaterialPageRoute(builder: (context) => UsersPage()));
                  MaterialPageRoute(builder: (context)=>HomeScreen()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMovieScreen("", "", "", "")));
        },
      ),
      body: Container(
          child: Query(
         options: QueryOptions(
         document: gql(fetchMovies)), 
        builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List movies = result.data?['movies'];

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return ExpansionTile(
                title: Text(
                  movie['title'],
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(movie['description'].toString()),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Chip(
                              avatar: Icon(Icons.account_circle),
                              label: Text(movie['director']),
                            ),
                          ],
                        ),
                        Center(
                          child: Chip(
                            label: Text(movie['title']),
                            avatar: Icon(Icons.account_circle),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Row(
                                children: [Icon(Icons.edit), Text("Edit")],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddMovieScreen(
                                          movie['id'],
                                          movie['title'],
                                          movie['description'],
                                          movie['director']),
                                    ));
                              },
                            ),
                           
                            Mutation(
                              options: MutationOptions(
                                  document: gql(deleteMovie),
                                  onCompleted: (dynamic resultData) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()));
                                  },
                            ),
                  
                              builder: (
                                RunMutation runMutation,
                                QueryResult? result,
                                 ) {                
                               return FlatButton(
                                  child: Row(
                                    children: [Icon(Icons.delete), Text("Delete")],
                                  ),
                                  onPressed: () {
                                    runMutation({
                                      'id': movie['id'],
                                    });
                                  },
                                );
                                },
                              
                            )
                            
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        },
      )
      ),
    );
  }
}