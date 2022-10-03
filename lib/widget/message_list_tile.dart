import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class MessageListTile extends StatelessWidget {
  Comment comment;
  MessageListTile({required this.comment});

  //final _currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: comment.userId == FirebaseAuth.instance.currentUser!.uid ? Radius.circular(15) : Radius.zero,
            topRight:  Radius.circular(15),
            bottomRight: comment.userId == FirebaseAuth.instance.currentUser!.uid ? Radius.zero : Radius.circular(15),
          ),
          color: Colors.blueGrey,
        ),
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: comment.userId == FirebaseAuth.instance.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:  comment.userId == FirebaseAuth.instance.currentUser!.uid ? CrossAxisAlignment.end: CrossAxisAlignment.start,
            children: [
              Text("By ${comment.userName}",style: TextStyle(fontSize: 12,),),
              SizedBox(height: 4,),
              Text(comment.message,style: TextStyle(fontSize: 16,),),
            ],
          ),
        ) ,),
    );
  }
}
