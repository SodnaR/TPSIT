import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:memo/db.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'methods/memo_dao.dart';
import 'entity/memo.dart';
import 'logIn.dart';

AppDatabase database;
MemoDao memoDao;
List<Memo> memi = <Memo>[], research = <Memo>[];

Memo modify;
TextEditingController searchController = TextEditingController();
String _mail;

File jsonFile =
    File('D:/schoolSubject/TIPSIT/TPSIT/memo/lib/assets/memo_copy.json');

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogIn(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext buildC;
  Future<List<Memo>> futureMemo;

  @override
  void initState() {
    super.initState();
    futureMemo = fetchMemi();
    $FloorAppDatabase.databaseBuilder('app_database.db').build().then((db) => {
          db.memoDao.findAllMemo().then((mm) => setState(() {
                database = db;
                memoDao = db.memoDao;
                memi = mm;
              }))
        });
    if (widget.title != null) _mail = widget.title;
  }

  Future<void> findRows() async {
    database.memoDao.findMemoByTitle(searchController.text).then((data) {
      setState(() {
        research = data;
      });
    });
  }

  Future<List<Memo>> fetchMemi() async {
    var response = await http.get(Uri.http('10.0.2.2:3000', '/Memo'));
    var responseMemi = json.decode(response.body) as List;
    if (response.statusCode == 200) {
      return responseMemi.map((e) => Memo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load memo');
    }
  }

  void _upToDate() async {
    futureMemo.then((memi) {
      memi.forEach((element) {
        database.memoDao.insertMemo(element);
      });
    });
  }

  //Cancella l'elemento corrispondente al Json
  Future<void> deleteJson(int id) async {
    var response = await http.delete(
      (Uri.http('10.0.2.2:3000', '/Memo/$id')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      print(response.body + " " + response.statusCode.toString());
      throw Exception('Failed to delete memo.');
    }
  }

  //all memo of the user
  @override
  Widget build(BuildContext context) {
    if (searchController.text.isEmpty)
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: memi.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          color: Colors.deepOrange[300],
                          child: Center(
                              child: TextButton(
                            onPressed: () {
                              modify = memi[index];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlterMemo()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('${memi[index].title}',
                                    style: TextStyle(fontSize: 18)),
                                new Spacer(),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      //Non si possono cancellare memo una volta condivisi
                                      //deleteJson(memi[index].id);
                                      database.memoDao.deleteMemo(memi[index]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()));
                                    })
                              ],
                            ),
                          )),
                        );
                      })),
              //Spacer(),
              TextField(
                controller: searchController,
                decoration: const InputDecoration(hintText: "Research"),
              ),
              IconButton(
                  icon: Icon(Icons.zoom_out),
                  onPressed: () {
                    findRows();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  })
            ],
          ),
        ),
        floatingActionButton: _getButtonsList(),
      );
    else
      return researchForTitle(context);
  }

  Scaffold researchForTitle(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: research.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        margin: EdgeInsets.all(2),
                        color: Colors.deepOrange[300],
                        child: Center(
                            child: TextButton(
                          onPressed: () {
                            modify = research[index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlterMemo()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('${research[index].title}',
                                  style: TextStyle(fontSize: 18)),
                              new Spacer(),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    //Non si possono cancellare memo una volta condivisi
                                    //deleteJson(research[index].id);
                                    database.memoDao
                                        .deleteMemo(research[index]);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage()));
                                  })
                            ],
                          ),
                        )),
                      );
                    })),
            //Spacer(),
            TextFormField(
              controller: searchController,
              decoration: const InputDecoration(hintText: "Research"),
            ),
            IconButton(
                icon: Icon(Icons.zoom_out),
                onPressed: () {
                  findRows();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: _getButtonsList(),
    );
  }

  Widget _getButtonsList() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.add),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewMemo()));
            }),

        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.refresh),
            onTap: () {
              _upToDate();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            }),
      ],
    );
  }
}

//new page for the creation of the new memo
class NewMemo extends StatelessWidget {
  final titleController = TextEditingController();
  final inputController = TextEditingController();
  final anchorController = TextEditingController();

  //can't upload on json
  int newId() {
    int index;
    for (index = 0; index < memi.length; index++) {
      if (memi[index].id > index) {
        return index;
      }
    }
    return index;
  }

  //add an element in the database
  void _addMemo(String anchor) async {
    Memo memo = new Memo(
        newId(), _mail, titleController.text, inputController.text, anchor);
    memoDao.insertMemo(memo);
    var response = await http.post(
      Uri.http('10.0.2.2:3000', '/Memo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': memo.id,
        'user': memo.user,
        'title': memo.title,
        'field': memo.field,
        'anchor': memo.anchor,
      }),
    );

    if (response.statusCode != 201) {
      print(response.body + " " + response.statusCode.toString());
      throw Exception('Failed to update memo.');
    }
    memoDao.deleteMemo(memo);
  }

  //Visual anchor adder
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: anchorController,
              decoration: InputDecoration(hintText: "#memo"),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('Share'),
                  onPressed: () {
                    _addMemo(anchorController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: _mail,
                              )),
                    );
                  }),
            ],
          );
        });
  }

  //Visual note
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: <Widget>[
          new Row(children: <Widget>[
            new Flexible(
              child: new TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
                // ignore: deprecated_member_use
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            TextButton(
                child: Text("Salva"),
                onPressed: () {
                  if (inputController.text.isEmpty &&
                      titleController.text.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    _displayTextInputDialog(context);
                  }
                })
          ]),
          Expanded(
              child: TextField(
            controller: inputController,
            scrollPadding: EdgeInsets.all(20.0),
            maxLines: 26,
            autofocus: true,
          ))
        ],
      ),
    );
  }
}

//new page for the creation of the new memo
class AlterMemo extends StatelessWidget {
  final titleController = TextEditingController(text: modify.title);
  final inputController = TextEditingController(text: modify.field);
  final anchorController = TextEditingController(text: modify.anchor);

  //modify an element in the database
  void _modifyMemo(String anchor) async {
    modify.user = _mail;
    modify.title = titleController.text;
    modify.field = inputController.text;
    modify.anchor = anchor;

    memoDao.modifyMemo(modify);

    var response = await http.put(
      Uri.http('10.0.2.2:3000', '/Memo/${modify.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': modify.id,
        'user': modify.user,
        'title': modify.title,
        'field': modify.field,
        'anchor': modify.anchor,
      }),
    );
    print(modify.title);
    if (response.statusCode != 200) {
      print(response.body + " " + response.statusCode.toString());
      throw Exception('Failed to update memo.');
    }
  }

  //Visual anchor adder
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextFormField(
              controller: anchorController,
              decoration: InputDecoration(hintText: "#memo"),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('Share'),
                  onPressed: () {
                    _modifyMemo(anchorController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: _mail,
                              )),
                    );
                  }),
            ],
          );
        });
  }

  //Visual note
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: <Widget>[
          new Row(children: <Widget>[
            new Flexible(
              child: new TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "title"),
                // ignore: deprecated_member_use
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            TextButton(
                child: Text("Salva"),
                onPressed: () {
                  if (inputController.text.isEmpty &&
                      titleController.text.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    _displayTextInputDialog(context);
                  }
                })
          ]),
          Expanded(
              child: TextFormField(
            controller: inputController,
            scrollPadding: EdgeInsets.all(20.0),
            maxLines: 26,
            autofocus: true,
          ))
        ],
      ),
    );
  }
}
