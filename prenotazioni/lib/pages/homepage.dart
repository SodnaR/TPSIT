import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prenotazioni/data/classi.dart';
import 'package:prenotazioni/main.dart' as room_import;
import 'package:prenotazioni/prenotationCalendar/calendarLibrary.dart';



class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Aula> aule;

  @override
  void initState() {
    super.initState();
    aule = room_import.stanze.stanze;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: aule.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < 6) {
                      return _private(index);
                    } else {
                      return _prenotable(index);
                    }
                  })),
        ],
      ),
    );
  }

  Widget _private(int index) {
    return Container(
      height: 50,
      margin: EdgeInsets.all(12.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.deepOrange[300],
      ),
      child: Center(
          child: TextButton(
        onPressed: () {
          showAlertDialog(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('${aule[index].intestazione}', style: TextStyle(fontSize: 18)),
            new Spacer(),
          ],
        ),
      )),
    );
  }

  Widget _prenotable(int index) {
    return Container(
      height: 50,
      margin: EdgeInsets.all(12.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.deepOrange[300],
      ),
      child: Center(
          child: TextButton(
        onPressed: () {
          //molto rudimentale
          //Impossibile avere un codice di creazione se si mantiene questa assegnazione di cambi
          switch (index) {
            case 6:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProjectionCalendar()));
              break;
            case 7:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LanguageCalendar()));
              break;
            case 8:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RelaxCalendar()));
              break;
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('${aule[index].intestazione}', style: TextStyle(fontSize: 18)),
            new Spacer(),
          ],
        ),
      )),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Prenotazione aula"),
      content: Text("Questa aula non è libera di essere prenotata"),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
