import 'package:flutter/material.dart';

import 'screens/notes_screen.dart';

void main() {
  runApp(const MyApp());
  
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Local Database demo app',
      theme: ThemeData(
        primarySwatch: Colors.green,
        
        // useMaterial3: false
      ),
      home: const NotesScreen(),
    );
  }
}
