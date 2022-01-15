import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../database_helper.dart';

class LoggedIn extends StatelessWidget {
  final String token;

  LoggedIn(this.token);

  static const routeName = '/loggedIn';

  Future<String> fetchData() async {
    final url = Uri.parse('SERVER_ADDRESS/PRODUCTS');

    final serverQuery =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    return serverQuery.body;
  }

  final storage = const FlutterSecureStorage();

  Map<String, dynamic> parseJwt(String token) {
    final result = DatabaseHelper().parseJwt(token);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final data = parseJwt(token);

    return Scaffold(
      appBar: AppBar(title: Text('Basic appbar')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                storage.deleteAll();
              },
              child: const Text('You\'re logged in'),
            ),
            Text(
              'Your Secret Data : $data',
            )
          ],
        ),
      ),
    );
  }
}
