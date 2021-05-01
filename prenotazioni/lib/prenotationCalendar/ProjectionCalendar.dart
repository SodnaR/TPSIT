import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:prenotazioni/data/prenotations.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:prenotazioni/main.dart' as prenotation_import;
import 'package:http/http.dart' as http;

final int _stanza = 7;
final projection = projectionCubit({});

Prenotation _prenotazione;

class ProjectionCalendar extends StatefulWidget {
  @override
  _ProjectionCalendarState createState() => _ProjectionCalendarState();
}

class _ProjectionCalendarState extends State<ProjectionCalendar> {
  CalendarController _controller;
  TextEditingController _eventController;

  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  DateTime _selectedPrenotation;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];

    _prenotazione =
        prenotation_import.prenotazioni.onlinePrenotation[(_stanza - 7)];
    final List<Time> events = _prenotazione.date;

    _events = Map.fromIterable(events,
        key: (e) => e.getDateTime(),
        value: (e) => events
            .where(
                (element) => areSameDay(e.getDateTime(), element.getDateTime()))
            .toList());
    projection.projection(_events);
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text('AULA PROIEZIONI'),
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
        onPressed: _selectTime,
      ),
    );
  }

  _selectTime() async {
    //La data si seleziona in aticipo
    //Selezione dell'ora
    TimeOfDay t = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 8, minute: 00));

    if (t != null) {
      setState(() {
        //Salvo la data della prenotazione
        _selectedPrenotation = DateTime(_controller.focusedDay.year,
            _controller.focusedDay.month, _controller.focusedDay.day, t.hour);

        //Se il giorno è selezionato posso creare la prenotazione
        if (_events[_controller.selectedDay] != null) {
          _prenotazione.date.add(Time(
              _selectedPrenotation.year,
              _selectedPrenotation.month,
              _selectedPrenotation.day,
              _selectedPrenotation.hour,
              prenotation_import.username));

          _events[_controller.selectedDay]
              .add(_prenotazione.date[(_prenotazione.date.length - 1)] as Time);
        } else {
          _events[_controller.selectedDay] = [];
          _prenotazione.date.add(Time(
              _selectedPrenotation.year,
              _selectedPrenotation.month,
              _selectedPrenotation.day,
              _selectedPrenotation.hour,
              prenotation_import.username));

          _events[_controller.selectedDay]
              .add(_prenotazione.date[(_prenotazione.date.length - 1)] as Time);
        }
        _eventController.clear();
      });
      projection.projection(_events);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProjectionCalendar()));
    }
  }
}

// ignore: camel_case_types
class projectionCubit extends Cubit<Map<DateTime, List<dynamic>>> {
  projectionCubit(Map<DateTime, List<dynamic>> initialState)
      : super(initialState);

  void projection(Map<DateTime, List<dynamic>> map) => emit(map);

  @override
  void onChange(Change<Map<DateTime, List<dynamic>>> change) {
    super.onChange(change);
    _modifyJson();
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}

Future<void> _modifyJson() async {
  var response = await http.put(
    Uri.http('10.0.2.2:3000', '/Prenotation/2'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': _prenotazione.codP,
      'idAula': _prenotazione.idAula,
      'date': _prenotazione.date
    }),
  );
  if (response.statusCode != 200) {
    print(response.body + " " + response.statusCode.toString());
    throw Exception('Failed to update prenotation');
  }
}
