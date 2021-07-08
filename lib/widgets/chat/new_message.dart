import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/auth.dart';

class NewMessage extends StatefulWidget {
  final String adId;

  const NewMessage(this.adId);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  _sendMessage(userId,adId) async {
    FocusScope.of(context).unfocus();
    //final user = FirebaseAuth.instance.currentUser;
    final userData = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    Firestore.instance.collection('chat').document(adId).collection(adId).add({
      'adId':widget.adId,
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userName': userData['name'],
      'userId': userId,
      'user_image': userData['imageUrl']
    });
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId= Provider.of<Auth>(context).userId;
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  hintText: 'Send a message',
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor))),
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _enteredMessage.trim().isEmpty ? null : _sendMessage(userId,widget.adId);
            },
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
