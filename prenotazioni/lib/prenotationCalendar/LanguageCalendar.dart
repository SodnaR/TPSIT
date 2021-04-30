import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:prenotazioni/data/prenotations.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:prenotazioni/main.dart' as prenotation_import;

final int _stanza = 8;
final language = languageCubit([]);

class LanguageCalendar extends StatefulWidget {
  @override
  _LanguageCalendarState createState() => _LanguageCalendarState();
}

class _LanguageCalendarState extends State<LanguageCalendar> {
  CalendarController _controller;
  TextEditingController _eventController;

  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  Prenotation prenotazione;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];

    prenotazione =
        prenotation_import.prenotazioni.onlinePrenotation[(_stanza - 7)];
    final List<Time> events = prenotazione.date;
    language.language(events);

    _events = Map.fromIterable(events,
        key: (e) => e.getDateTime(),
        value: (e) => events
            .where(
                (element) => areSameDay(e.getDateTime(), element.getDateTime()))
            .toList());
  }

  bool areSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text('AULA RELAX'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Colors.orange,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events, holidays) {
                setState(() {
                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            ),
            ..._selectedEvents.map((event) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 48),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              "${event.hour}:00",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Spacer(),
                            Text(
                              "${event.booker}",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white70,
              title: Text("Add Prenotation"),
              content: TextField(
                controller: _eventController,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;
                    addPrenotation();
                  },
                )
              ],
            ));
  }

  void addPrenotation() {
    print(_controller.selectedDay.year.toString());
    setState(() {
      if (_events[_controller.selectedDay] != null) {
        _events[_controller.selectedDay]
            .add(Time(2021, 04, 1, 12, prenotation_import.username));
      } else {
        _events[_controller.selectedDay] = [];
      }
      _eventController.clear();
      Navigator.pop(context);
    });
  }
}

// ignore: camel_case_types
class languageCubit extends Cubit<List<Time>> {
  languageCubit(List<Time> initialState) : super(initialState);

  void language(List<Time> list) => emit(list);

  @override
  void onChange(Change<List<Time>> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
