import 'package:flutter/material.dart';
import 'package:flutter_graphql/home_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:math' as math;

class AddMovieScreen extends StatefulWidget {
  var id, title, description, director;

  AddMovieScreen(this.id, this.title, this.description, this.director);

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  String updateMovie = """
    mutation UpdateMovie(\$id: ID!, \$data: UpdateTodoInput!) {
      action: updateMovie(id: \$id, data: \$data) {
        id
        title
        description
        director
      }
    }
  """;

  String createMovie = """
    mutation createMovie(\$movieInput: MovieInput!) {
      action: createMovie(movieInput: \$movieInput) {
        _id
        title
        description
        director
      
      }
    }
  """;

  TextEditingController? titleController, descController, directorController;

  String generateRandomUser() {
    math.Random rnd =  math.Random();
    int userId = 11 + rnd.nextInt(13);
    return userId.toString();
  }

  @override
  void initState() {
    titleController =  TextEditingController(text: widget.title);
    descController =  TextEditingController(text: widget.description);
    directorController =  TextEditingController(text: widget.director);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Title: ${widget.title}");
    print("Description: ${widget.description}");
    print("Director: ${widget.director}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Add/Update Movie"),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: "Enter title here", labelText: "Title"),
              ),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                    hintText: "Enter description here",
                    labelText: "Description"),
              ),
              TextFormField(
                controller: directorController,
                decoration: InputDecoration(
                    hintText: "Enter director here", labelText: "Director"),
              ),
              SizedBox(
                height: 20,
              ),
              Mutation(
                options: MutationOptions(
                    document:
                        widget.title == "" ? gql(createMovie) : gql(updateMovie),
                    onCompleted: (dynamic resultData) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomeScreen()));
                    }),
                builder: (RunMutation runMutation,QueryResult? result) {
                  return RaisedButton(
                    child: Text(
                        widget.title == "" ? "Create Movie" : "Update Movie"),
                    onPressed: () {
                     if (widget.title == "") {
                        runMutation({
                          'movieInput': {
                            'title': titleController!.text,
                            'description': descController!.text,
                            'director': directorController!.text,
                          }
                        });
                      }
                       else {
                        runMutation({
                          'id': widget.id,
                          'movieInput': {
                            'title': titleController!.text,
                            'description': descController!.text,
                            'director': directorController!.text
                          }
                        });
                      }
                    },
                  );
                },
              ),
            ],
          )),
    );
  }
}