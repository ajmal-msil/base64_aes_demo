import 'dart:convert';
import 'package:encrypt/encrypt.dart'as encrypt;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  String encodedText = '';
  String decodedText = '';
  String secretKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AES256 Encryption/Decryption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(labelText: 'Enter Text'),
            ),
            ElevatedButton(
              onPressed: () {
                String inputText = textEditingController.text;
                String base64EncodedKey = '5zGEdjNVGKByOLK9rSgIhg=='; // Replace with your encoded key

                // Decode the secret key from Base64
                List<int> keyBytes = base64.decode(base64EncodedKey);
                secretKey = utf8.decode(keyBytes);
                print(secretKey);
                // Encrypt using AES256
                final key = encrypt.Key.fromUtf8(secretKey);
                final iv = encrypt.IV.fromLength(16); // Initialization Vector (IV)

                final encrypter = encrypt.Encrypter(encrypt.AES(key));
                final encrypted = encrypter.encrypt(inputText, iv: iv);
                encodedText = encrypted.base64;
                setState(() {});
              },
              child: Text('Encrypt'),
            ),
            Text('Encrypted Text: $encodedText'),
            ElevatedButton(
              onPressed: () {
                // Decrypt using AES256
                final key = encrypt.Key.fromUtf8(secretKey);
                final iv = encrypt.IV.fromLength(16); // Initialization Vector (IV)

                final encrypter = encrypt.Encrypter(encrypt.AES(key));
                final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encodedText), iv: iv);
                decodedText = decrypted;
                setState(() {});
              },
              child: Text('Decrypt'),
            ),
            Text('Decrypted Text: $decodedText'),
          ],
        ),
      ),
    );
  }
}
