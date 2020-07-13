import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);

  //função para passar uma function entre classes
  final Function({String text, File imgFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  final TextEditingController _messageController = TextEditingController();
  //função limpar text
  void _resetText() {
    setState(() {
      _messageController.clear();
      _isComposing = false;
    });
  }

//imagem
  File _image;
  final picker = ImagePicker();

  //destruction
  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();

    if (response == null) {
      return;
    }

    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
        } else {
          _handleImage(response.file);
        }
      });
    }
  }

  //função para a imagem
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null)
      retrieveLostData();
    else
      _image = File(pickedFile.path);
    widget.sendMessage(imgFile: _image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          iconButtonCamera(),
          textField(),
          iconButtonSend(),
        ],
      ),
    );
  }

  //iconButton
  Widget iconButtonCamera() {
    return IconButton(
        icon: Icon(Icons.photo_camera),
        onPressed: () async {
          getImage();
        });
  }

//campo de Texto
  Widget textField() {
    return Expanded(
      child: TextField(
        controller: _messageController,
        decoration: InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
        onChanged: (text) {
          setState(() {
            _isComposing = text.isNotEmpty;
          });
        },
        onSubmitted: (text) {
          widget.sendMessage(text: text);
          _resetText();
        },
      ),
    );
  }

//iconButton enviar
  Widget iconButtonSend() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: _isComposing
          ? () {
              widget.sendMessage(text: _messageController.text);
              _resetText();
            }
          : null,
    );
  }

  void _handleImage(PickedFile file) {}
}
