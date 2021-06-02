import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socketio_bandas/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bandas = [
    Band(id: '1', name: 'panda', votes: 2),
    Band(id: '2', name: 'the strokes', votes: 1),
    Band(id: '3', name: 'queen', votes: 3),
    Band(id: '4', name: 'los tigres del norte', votes: 4),
  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          
        appBar: AppBar(
          title: Text("bands votes", style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white12,
        ),

        body: ListView.builder(
          itemCount: bandas.length,
          itemBuilder: (context, index) => _bandTile(bandas[index])
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _addNewBand,
        ),
    );
  }

  Widget _bandTile(Band banda) {
      return Dismissible(
          key: Key(banda.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (DismissDirection diretion){
            // TODO: hacer el delete en el server
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
              onTap: () => print(banda.name),
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
                  onPressed: ()=> _addBandToList(textController.text)
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
              onPressed: ()=> _addBandToList(textController.text),
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

  _addBandToList(String name){
    print(name);

    if (name.length>1) {
      this.bandas.add(new Band(
        id: DateTime.now().toString(), 
        name: name, 
        votes: 1
      ));

      setState(() {});
    }

    Navigator.pop(context);
  }
}