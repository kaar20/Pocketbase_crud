import 'package:flutter/material.dart';
// import 'package:pb_project/dash.dart';
import 'package:pb_project/post_Model.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  RegisterNewUser regis = RegisterNewUser();

  TextEditingController email = TextEditingController();

  TextEditingController pass = TextEditingController();
  List email1 = [];
  var pass1 = [];
  var ids = [];

  @override
  // final pb = PocketBase('http://10.0.2.2:8090');
  // final result = await pb.collection('posts').getList();
  Future getPost() async {
    final pb = PocketBase('http://10.0.2.2:8090');
    final result = await pb.collection('posts').getList();

    for (var i in result.items) {
      var email = i.getStringValue('email');
      var pass = i.getStringValue('password');
      var id = i.id;

      // setState(() {
      if (email1.contains(email) == false) {
        email1.add(email);
        // print(email);
      }
      pass1.add(pass);
      if (ids.contains(id) == false) {
        ids.add(id);
      }
      // });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    getPost();
    // });
  }

  @override
  bool isCreated = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      getPost();
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          title: Center(child: Text("CRUD OPERATIONS")),
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: isCreated
                    ? ListView(
                        children: [
                          Form(
                              child: Column(
                            children: [
                              TextFormField(
                                controller: email,
                                decoration:
                                    InputDecoration(label: Text('Enter Email')),
                              ),
                              TextFormField(
                                controller: pass,
                                decoration: InputDecoration(
                                  label: Text("Enter Password"),
                                ),
                              )
                            ],
                          )),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, '/dash');
                                final createNew =
                                    regis.register(email.text, pass.text);
                                createNew;
                              },
                              child: const Text("Realtime"),
                            ),
                          ),
                        ],
                      )
                    : FutureBuilder(
                        future: pb.collection('posts').getFullList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text('Loading....');
                            default:
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              return ListView.builder(
                                itemCount: email1.length,
                                itemBuilder: (context, index) {
                                  // return
                                  return ListTile(
                                      leading:
                                          CircleAvatar(child: Text('$index')),
                                      title: Text(email1[index]),
                                      trailing: GestureDetector(
                                        onTap: () async {
                                          await pb
                                              .collection('posts')
                                              .delete('${ids[index]}');
                                        },
                                        child: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                        ),
                                      ));
                                },
                              );
                          }
                        },
                      ))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isCreated = !isCreated;
              getPost();
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
