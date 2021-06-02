import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socketio_bandas/pages/home_page.dart';
import 'package:socketio_bandas/pages/status_page.dart';
import 'package:socketio_bandas/services/socket_service.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> SocketService(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'status',
        routes: {
          'home': (_) => HomePage(),
          'status': (_)=> StatusPage()
        },
      ),
    );
  }
}
