import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _status = ServerStatus.Connecting;

  get serverStatus => this._status;

  SocketService(){
    _initConfig();
  }

  _initConfig(){
     // Dart client
    IO.Socket socket = IO.io('http://192.168.0.127:3000',{
      'transports': ['websocket'],
      'autoConnect': true,
    });


    socket.onConnect((_) {
      this._status = ServerStatus.Online;
      notifyListeners();
    });

    socket.onDisconnect((_) {
      this._status = ServerStatus.Offline;
      notifyListeners();
    });

    socket.on('nuevo-mensaje', (data) => print('nuevo-mensaje: $data'));
  }
  
}