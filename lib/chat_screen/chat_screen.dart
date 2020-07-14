import 'dart:io';

import 'package:chat/chat_screen/text_composert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //var snackbar
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  //var usuario
  FirebaseUser _currentUser;
  //var google
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //metodo google user
  Future<FirebaseUser> _getUser() async {
    //verificar se existe usuario logado
    if (_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //realizar conexao com google autentication

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      //realizar o login
      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      //pegar o usuario no firebase
      final FirebaseUser user = authResult.user;
      return user;
    } catch (e) {
      e.printStackTrace();
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    //recuperar usuario quando algo mudar ou estado atual inicializar
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      _currentUser = user;
    });
  }

//enviar mensagem
  void _sendMessage({String text, File imgFile}) async {
    //obter usuario atual
    final FirebaseUser user = await _getUser();

//verificar se existe usuario logado, caso nao exibir snackbar
    if (user == null) {
      _globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Não foi possível realiz o login. Tente novamente!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    Map<String, dynamic> dataFirebase = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
    };
    //verificar se img é nulo
    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child("FilesMessage")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      dataFirebase['imageUrl'] = url;
    }

    //adicionar texto ao firebase
    if (text != null) dataFirebase['textMessage'] = text;

    //adicionar map ao firebase
    Firestore.instance.collection("Messages").add(dataFirebase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child:
                //utilizar streambuilder para recriar os dados atraves do firebase sempre que houver uma alteração
                StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("Messages").snapshots(),
              builder: (builder, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    );
                  default:
                    List<DocumentSnapshot> documents =
                        snapshot.data.documents.reversed.toList();

                    return ListView.builder(
                        reverse: true, // lista de baixo para cima
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          return ChatMessage(documents[index].data, true);
                        });
                }
              },
            ),
          ),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}

//appBar
Widget appBar() {
  return AppBar(
    centerTitle: true,
    title: Text(
      "Chat",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 25.0),
    ),
    backgroundColor: Colors.redAccent,
    elevation: 1,
  );
}
