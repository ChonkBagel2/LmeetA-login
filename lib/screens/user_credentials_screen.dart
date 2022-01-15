import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../screens/loggedIn_screen.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final storage = FlutterSecureStorage();

    String baseUrl = 'SERVER_ADDRESS';

    Map<String, String> userDetails = {};

    Future<String> tryLogIn(Map<String, String> userDetails) async {
      final url = Uri.parse(baseUrl +
          '/login/${userDetails['email']}-${userDetails['password']}');

      final reqBody = json.encode(
        userDetails,
      );

      try {
        var serverResponse =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.cThIIoDvwdueQB468K5xDc5633seEFoqwxjF_xSJyQQ';
        storage.write(key: 'userData', value: serverResponse);

        return serverResponse;

        // var serverResponse = await http.post(url, body: reqBody);

        // if (serverResponse.statusCode == 201) {
        //   var userData = json.decode(serverResponse.body);
        //   await storage.write(key: 'userData', value: userData);

        //   return '';
        // }
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error Occurred'),
            content: Text(error.toString()),
          ),
        );
        return '';
      }
      return '';
    }

    Future<void> submitForm() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        final loginReq = await tryLogIn(userDetails);

        if (loginReq != '') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => LoggedIn(loginReq),
            ),
          );
        }
      }
    }

    return Scaffold(
      // backgroundColor: Colors.teal,
      // appBar: AppBar(title: const Text('Basic login authenticate')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/Logo.png'),
                const SizedBox(height: 40),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Enter Your Mobile Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone Number cannot be empty';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits long';
                    }
                  },
                  onSaved: (value) {
                    userDetails['number'] = value.toString();
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                  onPressed: submitForm,
                  child: const Text('Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
