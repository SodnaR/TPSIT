# Morra cinese

Seconda prova del corso TPSIT

-seconda scelta

### Consegna

Creare una applicazione dart che permettesse grazie all'uso di un serverSocket la comunicazione tra 2 dispositivi.

### Scelta

Come già accennato mi sono messo a creare la seconda scelta per questo esercizio, un gioco. In questo caso la trasposizioni virtuale dell'antico gioco: morra cinese.

## Procedimento

### Parte client

Per l'applicazione, per ora senza una appropriata GUI, ho 3 metodi, di cui ne utilizzo solo 2 al momento corrente.

Il primo si interessa della connessione infatti, se non si connette al server, si avvia (anche se non è efficiente) una seconda app interna al codice:

    class ServerApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
            return MaterialApp(home: ServerNotFound(title: "Can't find the server"));
        }
    }   

Può tornare utile, per sviluppi futuri: questo è il codice che viene usato invece per flutter:

class ServerNotFound extends StatefulWidget {
  ServerNotFound({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ServerNotFoundState createState() => _ServerNotFoundState();
}

class _ServerNotFoundState extends State<ServerNotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [Text("Can't reach the server")],
        ),
      ),
    );
  }
}

L'altra applicazione invece viene eseguita a connessione effettuata, per ora rimanda direttamente al gioco della morra, in futuro potrà essere aggiornata con caricamenti.

Lo stateful widget della principale è l'originale di quella prima mostrata, quindi metterò direttamente il codice della parte di flutter:

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.mySocket}) : super(key: key);
  final String title;
  final Socket mySocket;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dot = ".";
  int no = 1;
  Stream searching;

  Stream<int> tick() async* {
    int i = 1;
    do {
      await Future.delayed(Duration(seconds: 3));
      yield ++i;
      if (i == 3) i = 1;
    } while (true);
  }

  String wait() {
    searching.listen((data) => pointAnimation());
    return dot;
  }

  void pointAnimation() {
    setState(() {
      switch (no) {
        case 1:
          no++;
          dot = "..";
          break;
        case 2:
          no++;
          dot = "...";
          break;
        case 3:
          no = 1;
          dot = ".";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    searching = tick();
    if (!_inGame) {
      return Scaffold(
        body: Center(
            child: Row(
          children: [
            Text("Waiting for opponent "),
            Text("${wait()}"),
          ],
        )),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(),//Row for points
                Row(children: <Widget>[
                  ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              widget.mySocket.write("sasso");
                            },
                            //child: Image.asset('immagini/sasso.png')),
                            child: Text("Sasso")),
                        FlatButton(
                            onPressed: () {
                              widget.mySocket.write("carta");
                            },
                            child: Text('Carta')),
                        FlatButton(
                            onPressed: () {
                              widget.mySocket.write("forbice");
                            },
                            child: Text('Forbici')),
                      ]),
                ])
              ],
            ),
          ));
    }
  }

  Widget myButton(String path) {
    return ImageButton(
      children: <Widget>[],
      width: 91,
      height: 36,
      paddingTop: 5,
      pressedImage: Image.asset(
        "${path}premuta.png",
      ),
      unpressedImage: Image.asset("$path.png"),
      onTap: () {
        print('test');
      },
    );
  }
}

Semplicemente mostra a schermo tre bottoni, le scelte nella classica morra, che mandano un evento al server che gestisce le richieste.

### Parte server

Il server di base, o meglio la [connessione a tale è stata presa dalla dispensa fornitaci dal professore](https://gitlab.com/divino.marchese/zuccante_src/-/blob/master/dart/io/es006_chatroom_server.dart), che stampa in cmd l'ip e la porta del client che si è connesso e ne gestisce l'arrivo.


void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 3000).then((ServerSocket socket) {
    server = socket;
    server.listen((client) {
      handleConnection(client);
    });
  });
}

Il metodo che gestisce il client, poi decidederà di inserirlo in una classe Room ed in una lista che contiene quest'ultime: 

void handleConnection(Socket client) {
  print('Connection from '
      '${client.remoteAddress.address}:${client.remotePort}');

  addChallenger(MorraCinese(client));

  client.write("Welcome to Chinese morra challenge");
}

void addChallenger(MorraCinese user) {
  Room room;
  rooms.isEmpty ? room = new Room() : room = rooms.last;
  if (!room.addPlayers(user)) {
    rooms.add(new Room(user));
  }
}

Il server però si compone di due classi:

Quella che gestisce i punti(da implementare), e che raccoglie le scelte del giocatore e gestisce le richieste da parte del dispositivo dopo che si è conneso: MorraCinese


class MorraCinese {
  Socket _user;
  String get _address => _user.remoteAddress.address;
  int get _port => _user.remotePort;

  String choose;
  int point = 0; //da implementare

  MorraCinese(Socket s) {
    _user = s;
    _user.listen(versus, onError: errorHandler, onDone: finishedHandler);
  }

  Future<void> versus(data) async {
    choose = new String.fromCharCodes(data).trim();
    // ignore: unnecessary_brace_in_string_interps
    print('${_address}:${_port}, choose:$choose');
    searchInRoom(this).game();
  }

  void errorHandler(error) {
    // ignore: unnecessary_brace_in_string_interps
    print('${_address}:${_port} Error: $error');
    removeChallenger(this);
    _user.close();
  }

  void finishedHandler() {
    // ignore: unnecessary_brace_in_string_interps
    print('${_address}:${_port} Disconnected');
    removeChallenger(this);
    _user.close();
  }

  void write(String message) {
    _user.write(message);
  }

  void setChoose(String choose) {
    this.choose = choose;
  }
}

La seconda classe principale classe è come già visto Room, una raccolta di soli due giocatori o meglio : 2 oggetti di MorraCinese.

class Room {
  List<MorraCinese> players = [];
  Stream match;

  Room([MorraCinese user]) {
    if (user != null) players.add(user);
    rooms.add(this);
  }

  List<MorraCinese> getPlayers() {
    return players;
  }

  bool addPlayers(MorraCinese player) {
    if (players.length < 2) {
      players.add(player);
      return true;
    }
    return false;
  }

  bool isEmpty() {
    return players.isEmpty;
  }

  void challenge() {
    switch (players[0].choose) {
      case "carta":
        if (players[1].choose == "sasso") {
          players[0].write("VITTORIA");
          players[1].write("SCONFITTA");
          players[0].point++;
          print("P1 win!\n");
        } else if (players[1].choose == "forbice") {
          players[1].write("VITTORIA");
          players[0].write("SCONFITTA");
          players[1].point++;
          print("P2 win!\n");
        } else {
          players[1].write("PAREGGIO");
          players[0].write("PAREGGIO");
          print("PAREGGIO!\n");
        }
        break;
      case "forbice":
        if (players[1].choose == "carta") {
          players[0].write("VITTORIA");
          players[1].write("SCONFITTA");
          players[0].point++;
          print("P1 win!\n");
        } else if (players[1].choose == "sasso") {
          players[1].write("VITTORIA");
          players[0].write("SCONFITTA");
          players[1].point++;
          print("P2 win!\n");
        } else {
          players[1].write("PAREGGIO");
          players[0].write("PAREGGIO");
          print("PAREGGIO!\n");
        }
        break;
      case "sasso":
        if (players[1].choose == "forbice") {
          players[0].write("VITTORIA");
          players[1].write("SCONFITTA");
          players[0].point++;
          print("P1 win!\n");
        } else if (players[1].choose == "carta") {
          players[1].write("VITTORIA");
          players[0].write("SCONFITTA");
          players[1].point++;
          print("P2 win!\n");
        } else {
          players[1].write("PAREGGIO");
          players[0].write("PAREGGIO");
          print("PAREGGIO!\n");
        }
        break;
    }
    players[0].choose = players[1].choose = null;
  }

  void game() {
    if (players.length == 2) {
      if (players[0].choose != null && players[1].choose != null) challenge();
    }
  }

  @override
  String toString() {
    return players.toString();
  }
}
