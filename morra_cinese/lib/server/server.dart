import 'dart:io';

// USE ALSO netcat 127.0.0.1 3000

// global variables

ServerSocket server;
List<Room> rooms = [];

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 3000).then((ServerSocket socket) {
    server = socket;
    server.listen((client) {
      handleConnection(client);
    });
  });
}

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

void removeChallenger(MorraCinese challenger) {
  Room room = searchInRoom(challenger);
  room.players.remove(challenger);
  if (room.isEmpty()) rooms.remove(room);
}

Room searchInRoom(MorraCinese challenger) {
  for (Room room in rooms) {
    for (MorraCinese user in room.getPlayers()) {
      if (identical(user, challenger)) {
        return room;
      }
    }
  }
  return null;
}

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
