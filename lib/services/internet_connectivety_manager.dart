import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionManager {
  final BuildContext context;

  InternetConnectionManager(this.context);

  void init() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _showInternetConnectionSnackBar();
      }
    });
  }

  void _showInternetConnectionSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(
              Icons.wifi,
              color: Colors.white,
            ), // No wifi icon
            SizedBox(width: 12), // Spacer between icon and text
            Text('Internet connection restored'),
          ],
        ),
        backgroundColor: Colors.green[300],
        duration: const Duration(seconds: 5), // Set duration to 2 seconds
        behavior: SnackBarBehavior.floating, // Set behavior to floating
        elevation: 8, // Set elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Set border radius
        ), // Change background color to green
      ),
    );
  }
}
