import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((event) {
      setState(() {
        _currentUser = event;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_currentUser != null ? 'Home' : 'Login'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _currentUser != null
                  ? [
                      Image.network(_currentUser!.photoUrl.toString()),
                      Text(_currentUser!.displayName.toString()),
                      ElevatedButton(
                          onPressed: () {
                            _googleSignIn.signOut();
                          },
                          child: Text("LOGOUT")),
                    ]
                  : [
                      ElevatedButton(
                          onPressed: () async {
                            await _handleSignIn();
                          },
                          child: Text("GOOGLE SIGNIN")),
                    ]),
        ),
      ),
    );
  }
}
