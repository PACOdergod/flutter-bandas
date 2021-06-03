import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:socketio_bandas/models/band.dart';
import 'package:socketio_bandas/services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bandas = [
    // Band(id: '1', name: 'panda', votes: 2),
    // Band(id: '2', name: 'the strokes', votes: 1),
    // Band(id: '3', name: 'queen', votes: 3),
    // Band(id: '4', name: 'los tigres del norte', votes: 4),
  ];

  @override
  void initState() { 
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', (data){
      this.bandas = (data as List)
        .map((band) => Band.fromMap(band))
        .toList();
      
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() { 
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
    
      appBar: AppBar(
        title: Text("bands votes", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online 
              ? Icon(Icons.check_circle, color: Colors.green, size: 33,)
              : Icon(Icons.offline_bolt, color: Colors.red, size: 33,)
          )
        ],
      ),

      body: Column(
        children: [
          
          _showGraph(),

          Expanded(
            child: ListView.builder(
              itemCount: bandas.length,
              itemBuilder: (context, index) => _bandTile(bandas[index])
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewBand,
      ),
    );
  }

  Widget _showGraph(){
    Map<String, double> dataMap = {'flutter': 0};

    bandas.forEach((banda) {
      dataMap.putIfAbsent(banda.name, () => banda.votes.toDouble());
    });

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap)
    );
  }

  Widget _bandTile(Band banda) {
    final socketService = Provider.of<SocketService>(context);

    return Dismissible(
        key: Key(banda.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (_){
          socketService.socket.emit('delete-band', {'id':banda.id});
        },

        background: Container(
          padding: EdgeInsets.only(left: 10),
          color: Colors.red, 
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Delete', style: TextStyle(color: Colors.white),),
          )
        ),

        child: ListTile(
            leading: CircleAvatar(child: Text(banda.name.substring(0, 2))),
            title: Text( banda.name ),
            trailing: Text( '${banda.votes}', style: TextStyle( fontSize: 20 ) ),
            onTap: (){
              socketService.socket.emit('votar', { 'id': banda.id });
              // print(banda.id);
            },
        ),
    );
  } 

  _addNewBand() {
      final textController = TextEditingController();

      if (Platform.isAndroid) showDialog(
        context: context,
        builder: (context) => AlertDialog (
          title: Text('Nombre:',style: TextStyle(fontSize: 15),),
          content: TextField(controller: textController,),

          actions: [MaterialButton(
            child: Text('Add'),
            textColor: Colors.black,
            onPressed: ()=> _addBand(textController.text, context)
          )],
        )
      );
      
    if (Platform.isIOS) showCupertinoDialog(
      context: context, 
      builder: (_) => CupertinoAlertDialog(
        title: Text('Nombre'),
        content: CupertinoTextField( controller: textController ),

        actions: [
          CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Add"),
              onPressed: ()=> _addBand(textController.text, context),
          ),
          CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Dismiss"),
              onPressed: ()=> Navigator.pop(context),
          ),
        ],
      )
    );
  }

  _addBand(String name, BuildContext context){
    final socketService = Provider.of<SocketService>(context, listen: false);

    if (name.length>1) {
      socketService.socket.emit('new-band', {'nombre': name});
    }

    Navigator.pop(context);
  }
}