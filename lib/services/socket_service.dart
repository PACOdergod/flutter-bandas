import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _status = ServerStatus.Connecting;
  IO.Socket _socket = IO.io('http://192.168.0.127:3000',{
      'transports': ['websocket'],
      'autoConnect': true,
  });

  ServerStatus get serverStatus => this._status;
  IO.Socket get socket => this._socket;

  SocketService(){
    _initConfig();
  }

  _initConfig(){
     // Dart client

    this._socket.onConnect((_) {
      this._status = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._status = ServerStatus.Offline;
      notifyListeners();
    });

    // this._socket.on('nuevo-mensaje', (data) {
    //   print('mensaje del servidor:');
    //   print(data);
    // });
  }
  
}