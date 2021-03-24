# Open Memo app.

## Getting Started

Used languages:

##   - Flutter ○ # client view
##   - Dart ○ # class control and data manage
##   - Json ○ # server json

This application is divided in 3 parts, all interrelated each other.

# Flutter part

This part is condensed in the main.dart

### divided by the refenced page

## View of all memo

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

## View of the researched memo

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

This are the main page where the user can see the memos.

But there is also the needing to create or modify a memo, which has the same page but with different methods

### Memo fields page

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

# Dart part

We can see the methods with which input user data can be loaded into local files

## add a memo

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

## modify a memo

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


These methods are using two database, one is local keep, and one is offered by a local server.

The local store of a database is managed by the package [floor](https://pub.dev/packages/floor "floor dart documentation") which can be auto-generated by is [generator](https://pub.dev/packages/floor_generator "floor_generator dart official documentation").
To understand the database manage class, look the documentation in this links.

# Json part

Json server is a simple and easy start server, which can give http response to load from and on the web, for the documentation [click here](https://github.com/typicode/json-server "json-server documentation").

The json file, is saved in this repository in the directory *[./lib/assets](https://github.com/SodnaR/TPSIT/tree/main/memo/lib/assets)*, if you want to check how it is written.

