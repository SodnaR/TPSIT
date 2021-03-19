import 'package:memo/db.dart';
import 'package:flutter/material.dart';

import 'methods/memo_dao.dart';
import 'entity/memo.dart';

AppDatabase database;
MemoDao memoDao;
List<Memo> memi = <Memo>[];
String _mail;

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('app_database.db').build().then((db) => {
          db.memoDao.findAllMemo().then((mm) => setState(() {
                database = db;
                memoDao = db.memoDao;
                memi = mm;
              }))
        });
  }

  //all memo of the user
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
                        color: Colors.red[100],
                        child: Center(
                            child: Text(
                          '${memi[index].title}',
                          style: TextStyle(fontSize: 18),
                        )),
                      );
                    })),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add a memo',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewMemo()),
            );
          }),
    );
  }
}

//new page for the creation of the new memo
class NewMemo extends StatelessWidget {
  final titleController = TextEditingController();
  final inputController = TextEditingController();
  final anchorController = TextEditingController();

  //add an element in the database
  void _addMemo(String anchor) {
    Memo memo = new Memo(titleController.text, inputController.text, anchor);
    memoDao.insertMemo(memo);
    memi.add(memo);
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
                                title: "Memo browser",
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
              child: new TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
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

class _loginState extends StatelessWidget {
  final emailController = TextEditingController();
  final pswController = TextEditingController();

  String _psw;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
