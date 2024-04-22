import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';
import '../services/internet_connectivety_manager.dart';
import '../widgets/note_widget.dart';
import 'note_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // final Connectivity _connectivity = Connectivity();
  late InternetConnectionManager _connectionManager;

  @override
  void initState() {
    super.initState();
    _connectionManager = InternetConnectionManager(context);
    _connectionManager.init();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('Notes' , style: TextStyle(
            color: Colors.white,
          fontWeight: FontWeight.bold , 
          fontSize: 26), ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[400],
        onPressed: () async {
          // Check if the device is online before navigating to the add note
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult != ConnectivityResult.none) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoteScreen(),
              ),
            );
            setState(() {});
          } else {
            // Show a toast if the device is offline
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                
                content: const Row(
                  children: [
                    Icon(Icons.wifi_off , color: Colors.white,), // No wifi icon
                    SizedBox(width: 12), // Spacer between icon and text
                    Text('No Internet Connection' ),
                  ],
                ),
                 duration:
                    const Duration(seconds: 5), // Set duration to 2 seconds
                behavior: SnackBarBehavior.floating, // Set behavior to floating
                backgroundColor: Colors.black45, // Set background color
                elevation: 8, // Set elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.add ,  color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<Note>?>(
        future: DatabaseHelper.getAllNotes(),
        builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) => NoteWidget(
                  note: snapshot.data![index],
                  onTap: () async {
                    
                   // Check if the device is online before navigating to the add note
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult != ConnectivityResult.none) {
             await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(
                          note: snapshot.data![index],
                        ),
                      ),
                    );
                    setState(() {},);
                  } else {
                      // Show a toast if the device is offline
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.wifi_off,
                                color: Colors.white,
                              ), // No wifi icon
                              SizedBox(
                                  width: 12), // Spacer between icon and text
                              Text('No Internet Connection'),
                            ],
                          ),
                          duration: const Duration(
                              seconds: 5), // Set duration to 2 seconds
                          behavior: SnackBarBehavior
                              .floating, // Set behavior to floating
                          backgroundColor:
                              Colors.black45, // Set background color
                          elevation: 8, // Set elevation
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Set border radius
                          ),
                        ),
                      );
                    }
                  },
                  onLongPress: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                              'Are you sure you want to delete this note?'),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                              onPressed: () async {
                                await DatabaseHelper.deleteNote(
                                    snapshot.data![index]);
                                Navigator.pop(context);
                                setState(
                                  () {},
                                );
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                itemCount: snapshot.data!.length,
              );
            }
            return const Center(
              child: Text('No notes yet'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
