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
                onPressed: addNewBand,
            ),
        );
    }

    ListTile _bandTile(Band banda) {
        return ListTile(
            leading: CircleAvatar(child: Text(banda.name.substring(0, 2))),
            title: Text( banda.name ),
            trailing: Text( '${banda.votes}', style: TextStyle( fontSize: 20 ) ),
            onTap: () => print(banda.name),
        );
    } 

    addNewBand() {
        final textController = TextEditingController();

        if (Platform.isAndroid) showDialog(
            context: context,
            builder: (context) => AlertDialog (
                title: Text('Nombre:',style: TextStyle(fontSize: 15),),
                content: TextField(controller: textController,),

                actions: [MaterialButton(
                    child: Text('Add'),
                    textColor: Colors.black,
                    onPressed: ()=>addBandToList(textController.text)
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
                        onPressed: ()=> addBandToList(textController.text),
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

    addBandToList(String name){
        print(name);

        Navigator.pop(context);
    }
}


