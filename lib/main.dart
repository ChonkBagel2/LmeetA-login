import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt/screens/loggedIn_screen.dart';

import './screens/user_credentials_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();

  findJwt() async {
    // await Future.delayed(
    //   const Duration(seconds: 3),
    // );
    final userData = await storage.read(key: 'userData');

    if (userData != null) {
      return userData;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JWT Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: findJwt(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return LoggedIn(snapshot.data.toString());
            }
            else {
              return Authentication();
            }
          },
        ),
      ),
    );
  }
}
