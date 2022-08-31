import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(  options: DefaultFirebaseOptions.currentPlatform,);

  runApp(
     MaterialApp(
      title: 'Google Sign In',
      home: SignInDemo(),
    ),
  );
}

class SignInDemo extends StatefulWidget {
  SignInDemo({Key? key}) : super(key: key);
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {

  UserCredential? _uc;
  String _contactText = '';
  @override
  void initState() {
    super.initState();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    debugPrint("hola inside 1" );
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    debugPrint("hola inside 2");
    debugPrint ( googleUser?.email.toString());
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    debugPrint("hola inside 3");
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    debugPrint("hola inside 4 " + googleAuth!.accessToken.toString() + "   "
        + googleAuth.idToken.toString());
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _handleSignIn() async {
    try {
      debugPrint("hola 1 before signInWithGoogle");
      _uc = await signInWithGoogle(); // to get firebase credentials.
      debugPrint("hola 2 aft signInWithGoogle email is ... " + _uc!.user!.email.toString());

    } catch (error) {
      print(error);
    }
  }


  Future<void> test_insert() async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final mountainsRef = storageRef.child("hello.txt");

      String my_encoded = base64.encode(utf8.encode('hello world oriol'));
      await mountainsRef.putString(my_encoded, format: PutStringFormat.base64);

      Uint8List? img = await mountainsRef.getData();
      String my_decoded = "";

      debugPrint(" img.toString()" +     my_decoded);
      String url_cloud = await mountainsRef.getDownloadURL();


      setState(() {
        _contactText = _contactText  + " url cloud  " + url_cloud + "  " + my_decoded;
        debugPrint(_contactText);
      });
    } on FirebaseException catch (e) {
      // ...
    }
  }
  Widget _buildBody() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(_contactText),
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
          ElevatedButton(
            onPressed: () =>   GoogleSignIn().signOut(),
            child: const Text('SIGN out'),
          ),
          ElevatedButton(
            child: const Text('POST TO FIRESTORE'),
            onPressed: () => test_insert(),
          ),
        ],
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}