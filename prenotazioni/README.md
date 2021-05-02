# Seconda consegna: APP prenotazioni

## -Compito:

-Realizzare una applicazioni che permettesse di prenotare le aule di una scuola

Per realizzarla avere un database gestito da un server locale a cui fare richieste; >[server json utilizzato per effettuare le richieste](https://github.com/typicode/json-server)<
Ed utilizzare la documentazione di [Cubit](https://pub.dev/documentation/cubit/latest/) per realizzarne di personalizzati per gestire i dati.

### dati usati nel database

* Aula _composto da_:
    * id
    * intestazione

    Aula(this.idAula, this.intestazione);

* Utente _composto da_:
    * email
    * password *non _crittografata_*
    * username

    Utente(this.email, this.password, this.username);

* Prenotazioni _composto da_:
    * id
    * idAula
    * date (data di prenotazione *e chi ha prenotato*) 
        * year
        * month
        * day
        * hour
        * username

    Prenotation(this.codP, this.idAula, this.date);

    Time(this.year, this.month, this.day, this.hour, this booker);


## Struttura

L'app si divide in varie finestre, visive: 

* Login (solo gli utenti **attualmente** presenti nel database possono accedere)
* Homepage (vista di tutte le aule, *più o meno prenotabili*)
* Pagina di prenotazione (**cambia per ogni aula** e dove ognuna mantiene le proprie prenotazioni)

Per l'operatività è tutta incentrata nel main, che crea le basi per gestire i vari dati:

* Get:
        
    //creazione e condivisione degli utenti dal main
    * Utenti _users;
    * Utenti get users => _users;

    //creazione e condivisione delle aule dal main
    * Aule _stanze;
    * Aule get stanze => _stanze;

    //nome dell'utente
    * String username;

    //creazione e condivisione database prenotazioni locale
    * LocalPrenotations _prenotazioni;
    * LocalPrenotations get prenotazioni => _prenotazioni;

Setup:

    void main() {
        _users = new Utenti();
        _stanze = new Aule();
        _prenotazioni = new LocalPrenotations();
        Bloc.observer = MyBlocObserver();
        runApp(MyApp());
    }

    class MyApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
            _users = new Utenti();
            return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: Login(),
            );
        }
    }

### Pagina di Login

Pagina spoglia dove l'utente inserisce i dati (*pagina di registrazione al momento inesistente*) tra cui: _email e password_ che se corrette permettono l'accesso all'app. Previo controllo di esistenza sul database.

#### codice di controllo:

    List<Utente> users;

    final emailController = TextEditingController();
    final pswController = TextEditingController();
    bool obscure = true;

    @override
    void initState() {
        super.initState();
        users = user_import.users.utenti;
    }

    bool logged() {
        bool _return = false;
        users.forEach((user) {
        if (user.email.compareTo(emailController.text) == 0) {
            if (user.password.compareTo(pswController.text) == 0) {
            _return = true;
            setState(() {
                username.nickname(user.username);
            });
            }
        }
        });
        return _return;
    }

#### Salvataggio dell'utente:

Per salvare i dati dell'utente, in questo caso solo il nickname usiamo un cubit (*scelta ridontante fino alla possibilità di poter cambiare l'account prima di uscire dall'app*)


    class userCubit extends Cubit<String> {
        userCubit(String initialState) : super(initialState);

        void nickname(String username) => emit(username);

        @override
        void onChange(Change<String> change) {
            super.onChange(change);
            user_import.setUser(change.nextState.toString());
            print("$change from user");
        }

        @override
        void onError(Object error, StackTrace stackTrace) {
            print('$error, $stackTrace');
            super.onError(error, stackTrace);
        }
    }

### Pagina di visualizzazione delle classi

In questa pagina si visualizzano tutte le aule prenotabili o meno. Le classi infatti non sono prenotabili (controllate dall'id, possibile miglioramento con aggiunta di parametri).

#### inizializzazione

    List<Aula> aule;

    @override
    void initState() {
        super.initState();
        aule = room_import.stanze.stanze;
    }

#### aule non prenotabili

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

#### Aule prenotabili

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

### Pagina di prenotazione

Ogni classe ha la propria ma sono tutte costrutire in modo parallelo, tramite [table_calendar](https://pub.dev/packages/table_calendar) che nel mio caso son riuscito a ricostrutire grazie ad un [tutorial](https://medium.com/flutterdevs/display-dynamic-events-at-calendar-in-flutter-22b69b29daf6) (*non seguito alla lettera*).

Con un pacchetto si potrebbe tranquillamente gestirne la creazione in modo automatico, ma non è questo il caso.

#### inizializzazione

Anche in questa situazione possiamo usare i cubit dove possiamo notificare il cambio di uno stato con l'aggiunta di una nuova prenotazione

> Ogni calendario ha i propri cubit, gestiti dal controller nel main.

    
    final int _stanza = 9;
    final relax = relaxCubit({});


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
        relax.relax(_events);
    }

    bool areSameDay(DateTime date1, DateTime date2) {
        return date1.day == date2.day &&
            date1.month == date2.month &&
            date1.year == date2.year;
    }

#### Controllo e presa dei dati

I dati vengono presi da un orologio a comparsa, nella data prima selezionata, ed avvertono il cubit.

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
        relax.relax(_events);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RelaxCalendar()));
        }
    }
    }

##### Cubit delle classi calendario

    // ignore: camel_case_types
    class relaxCubit extends Cubit<Map<DateTime, List<dynamic>>> {
        relaxCubit(Map<DateTime, List<dynamic>> initialState) : super(initialState);

        void relax(Map<DateTime, List<dynamic>> map) {
            emit(map);
    }

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

Ogni calendario ha il proprio riferimento alla parte di database che gli appartiene

    Future<void> _modifyJson() async {
        var response = await http.put(
            Uri.http('10.0.2.2:3000', '/Prenotation/3'),
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

## UML dei cubit

      ![foto_non_trovata](https://github.com/SodnaR/TPSIT/blob/main/prenotazioni/UML.png)
