import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data, this.mine);
  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          !mine
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: circularImage(),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  //se nao for meu, coloco no inicio, se for passo pro fim da tela
                  !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: <Widget>[
                textNomeEnviou(),
                //verificar se imagem é nula
                data['imageUrl'] != null
                    ? Image.network(
                        data['imageUrl'],
                        width: 250.0,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: textMensagemEnviada(),
                      ),
                textTimeSend(),
              ],
            ),
          ),
          //caso eu tenha enviado mensagem, mensagem ficará do lado direito
          mine
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: circularImage(),
                )
              : Container(),
        ],
      ),
    );
  }

  //imagem circular
  Widget circularImage() {
    return CircleAvatar(
      backgroundImage: NetworkImage(data['senderPhotoUrl']),
    );
  }

  //texto nome
  Widget textNomeEnviou() {
    return Text(
      data['senderName'],
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  //texto mensagem
  Widget textMensagemEnviada() {
    return Text(
      data['textMessage'],
      //caso mensagem seja minha e caso nao
      textAlign: !mine ? TextAlign.start : TextAlign.end,
      style: TextStyle(fontSize: 20.0, color: Colors.black54),
    );
  }

  //texto hora envio
  Widget textTimeSend() {
    return Text(
      data['timeSend'].toString(),
      //caso mensagem seja minha e caso nao
      textAlign: !mine ? TextAlign.start : TextAlign.end,
      style: TextStyle(fontSize: 16.0, color: Colors.black45),
    );
  }
}
