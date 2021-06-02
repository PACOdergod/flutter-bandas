import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketio_bandas/services/socket_service.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Text('${socketService.serverStatus}')
          ],
        )
     ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket.emit('nuevo-mensaje', 
          {'nombre':'Flutter', 'mensaje':'hola desde flutter'});
          print('emitiendo mensaje');
        },
        child: Icon(Icons.message),
     ),
   );
  }
}