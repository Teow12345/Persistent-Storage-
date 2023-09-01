import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final YourClass yourClass = YourClass();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? displayedDocument; // Added this variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storage'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await yourClass.saveLoginInfo(
                    usernameController.text,
                    passwordController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login Info saved.'),
                    ),
                  );
                },
                child: Text('Save Login Info'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? loginInfo = await yourClass.readLoginInfo();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login Info: $loginInfo'),
                    ),
                  );
                },
                child: Text('Show Login Info'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await yourClass.saveDocument();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Document saved.'),
                    ),
                  );
                },
                child: Text('Save Document'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? document = await yourClass.readDocument();
                  setState(() {
                    displayedDocument = document;
                  });
                },
                child: Text('Show Document'),
              ),
              SizedBox(height: 16),
              if (displayedDocument != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Document Content:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      displayedDocument!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),


              ElevatedButton(
                onPressed: () async {
                  await yourClass.saveAppPreferences();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('App Preferences saved.'),
                    ),
                  );
                },
                child: Text('Save App Preferences'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> preferences = await yourClass.loadAppPreferences();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('App Preferences: $preferences'),
                    ),
                  );
                },
                child: Text('Show App Preferences'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await yourClass.saveCacheFile();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cache File URL saved.'),
                    ),
                  );
                },
                child: Text('Save Cache File'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await yourClass.showSavedData(context);
                },
                child: Text('Show Saved Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YourClass {
  final SecureStorage secureStorage = SecureStorage();

  Future<void> saveLoginInfo(String username, String password) async {
    await _saveLoginInfoInBackground({'username': username, 'password': password});
  }

  static Future<void> _saveLoginInfoInBackground(Map<String, dynamic> data) async {
    final SecureStorage secureStorage = SecureStorage();
    await secureStorage.write('username', data['username']);
    await secureStorage.write('password', data['password']);
  }

  Future<String?> readLoginInfo() async {
    return await _readLoginInfoInBackground();
  }

  Future<String?> _readLoginInfoInBackground() async {
    final SecureStorage secureStorage = SecureStorage();
    String? username = await secureStorage.read('username');
    String? password = await secureStorage.read('password');
    return 'Username: $username, Password: $password';
  }

  Future<void> saveDocument() async {
    final Map<String, dynamic> documentData = {
      'title': 'My Document',
      'content': 'This is the content of my document.',
    };
    await _saveDocumentInBackground(documentData);
  }

  Future<void> _saveDocumentInBackground(Map<String, dynamic> documentData) async {
    final SecureStorage secureStorage = SecureStorage();
    await secureStorage.write('document', json.encode(documentData));
  }

  Future<String?> readDocument() async {
    return await _readDocumentInBackground();
  }

  Future<String?> _readDocumentInBackground() async {
    final SecureStorage secureStorage = SecureStorage();
    return await secureStorage.read('document');
  }

  Future<void> saveAppPreferences() async {
    final Map<String, dynamic> appPreferences = {
      'theme': 'dark',
      'language': 'english',
    };
    await _saveAppPreferencesInBackground(appPreferences);
  }

  Future<void> _saveAppPreferencesInBackground(Map<String, dynamic> appPreferences) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('app_preferences', json.encode(appPreferences));
  }

  Future<Map<String, dynamic>> loadAppPreferences() async {
    return await _loadAppPreferencesInBackground();
  }

  Future<Map<String, dynamic>> _loadAppPreferencesInBackground() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String preferencesString = prefs.getString('app_preferences') ?? '{}';
    return json.decode(preferencesString);
  }

  Future<void> saveCacheFile() async {
    // Simulate downloading a PDF file
    final String pdfUrl = 'https://example.com/sample.pdf';
    await _saveCacheFileInBackground(pdfUrl);
  }

  Future<void> _saveCacheFileInBackground(String pdfUrl) async {
    final SecureStorage secureStorage = SecureStorage();
    await secureStorage.write('cache_pdf_url', pdfUrl);
  }

  Future<void> showSavedData(BuildContext context) async {
    final loginInfo = await readLoginInfo();
    final document = await readDocument();
    final appPreferences = await loadAppPreferences();
    final cacheFileUrl = await secureStorage.read('cache_pdf_url');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saved Data'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Login Info: $loginInfo'),
              SizedBox(height: 16),
              Text('Document: $document'),
              SizedBox(height: 16),
              Text('App Preferences: $appPreferences'),
              SizedBox(height: 16),
              Text('Cache File URL: $cacheFileUrl'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }
}

