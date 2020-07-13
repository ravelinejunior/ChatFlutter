import 'package:chat/chat_screen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MaterialApp(
    home: ChatScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.white,
      primaryColorDark: Colors.redAccent,
      accentColor: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.red,
      ),
    ),
  ));

  /* Firestore.instance.collection("Mensagens").document().setData(
    {
      "mensagem": "Ahham ?",
      "from": "Marina",
      "to": "Raveline",
      "read": true,
    },
  ); */

  /*  QuerySnapshot snapshot =
      await Firestore.instance.collection("Mensagens").getDocuments();
  snapshot.documents.forEach((d) {
    // d.reference.updateData({"lido": true});
    print(d.data);
    print(d.documentID);
  });

  Firestore.instance.collection("Mensagens").snapshots().listen((snapshot) {
    snapshot.documents.forEach((d) {
      print("Alterado" + d.data.toString());
    });
  }); */
}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
