import 'dart:io';

// USE ALSO netcat 127.0.0.1 3000

// global variables

ServerSocket server;
//List<ChatClient> clients = [];
List<List<MorraCinese>> rooms = [];

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

  //clients.add(ChatClient(client));
  addChallenger(MorraCinese(client));

  client.write("Welcome to Chinese morra challenge");
}

void addChallenger(MorraCinese user) {
  List<MorraCinese> room = searchInRoom(user);
  if (room == null) {
    rooms.add([user]);
  } else {
    room.add(user);
  }
}

/*
void removeClient(ChatClient client) {
  clients.remove(client);
}
*/
void removeChallenger(MorraCinese challenger) {
  List<MorraCinese> room = searchInRoom(challenger);
  room.remove(challenger);
  if (room.isEmpty) rooms.remove(room);
}

/*
void distributeMessage(ChatClient client, String message) {
  for (ChatClient c in clients) {
    if (c != client) {
      c.write(message + "\n");
    }
  }
}
*/
void versus(MorraCinese challenger, String choose) {
  List<MorraCinese> room = searchInRoom(challenger);
  MorraCinese opponent = identical(room[0], challenger) ? room[1] : room[0];
  do {
    if (opponent.choose != null) {
      challenge(challenger, opponent);
    }
  } while (opponent.choose == null);
  challenger.setChoose(null);
  opponent.setChoose(null);
}

void challenge(MorraCinese p1, MorraCinese p2) {
  if (identical(p1.choose, p2.choose)) {
    p1.write("PAREGGIO");
    p2.write("PAREGGIO");
  } else {
    switch (p1.choose) {
      case "carta":
        if (identical(p2.choose, "sasso")) {
          p1.write("VITTORIA");
          p2.write("SCONFITTA");
          p1.point++;
        } else {
          p2.write("VITTORIA");
          p1.write("SCONFITTA");
          p2.point++;
        }
        break;
      case "forbice":
        if (identical(p2.choose, "carta")) {
          p1.write("VITTORIA");
          p2.write("SCONFITTA");
          p1.point++;
        } else {
          p2.write("VITTORIA");
          p1.write("SCONFITTA");
          p2.point++;
        }
        break;
      case "sasso":
        if (identical(p2.choose, "forbice")) {
          p1.write("VITTORIA");
          p2.write("SCONFITTA");
          p1.point++;
        } else {
          p2.write("VITTORIA");
          p1.write("SCONFITTA");
          p2.point++;
        }
        break;
    }
  }
}

List<MorraCinese> searchInRoom(MorraCinese challenger) {
  for (List<MorraCinese> room in rooms) {
    for (MorraCinese user in room) {
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
    _user.listen(challenge, onError: errorHandler, onDone: finishedHandler);
  }

  void challenge(data) {
    choose = new String.fromCharCodes(data).trim();
    versus(this, choose);
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
/*

// ChatClient class for server

class ChatClient {
  Socket _socket;
  String get _address => _socket.remoteAddress.address;
  int get _port => _socket.remotePort;

  ChatClient(Socket s) {
    _socket = s;
    _socket.listen(messageHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void messageHandler(data) {
    String message = new String.fromCharCodes(data).trim();
    // ignore: unnecessary_brace_in_string_interps
    distributeMessage(this, '${_address}:${_port} Message: $message');
  }

  void errorHandler(error) {
    // ignore: unnecessary_brace_in_string_interps
    print('${_address}:${_port} Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    // ignore: unnecessary_brace_in_string_interps
    print('${_address}:${_port} Disconnected');
    removeClient(this);
    _socket.close();
  }

  void write(String message) {
    _socket.write(message);
  }
}
*/
