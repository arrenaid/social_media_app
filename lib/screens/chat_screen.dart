import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/widget/message_list_tile.dart';

import '../models/chat_model.dart';
class ChatScreen extends StatefulWidget {
  static const String id ="chat_screen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String _message;
  late TextEditingController _controller;
  late final _currentUserID;

  @override
  void initState() {
    _controller = TextEditingController();
    _currentUserID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final Post _doc =  ModalRoute.of(context)!.settings.arguments as Post;
    return Scaffold(
      appBar: AppBar(title: Text(_doc.description), centerTitle: true,),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(Post.posts).doc(_doc.id)
                    .collection(Comment.comments).orderBy(Comment.colTms)
                    .snapshots(),
                builder: (context, snapshot){

                  if(snapshot.hasError){
                    return Center(child: Text("error"));
                  }

                  if(snapshot.connectionState == ConnectionState.waiting
                      || snapshot.connectionState == ConnectionState.none){
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context,index) {

                      final doc = snapshot.data!.docs[index];
                      final Comment comment = Comment(
                          userName: doc[Comment.colUN],
                          userId: doc[Comment.colUI],
                          timestamp: doc[Comment.colTms],
                          message: doc[Comment.colMes]);

                    return Align(
                      alignment: comment.userId == _currentUserID
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: MessageListTile(comment: comment),
                    );
                  });
                },
              ),
            ),
            Container(
              color: Colors.blueGrey,
              height: MediaQuery.of(context).size.height/10,
              //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                  child: TextField(
                    controller: _controller,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: "Enter message",
                    ),
                    onChanged: (value){
                      _message = value;
                    },
                  ),
                )),
                Container(
                  width: MediaQuery.of(context).size.width/8,
                  child: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance.collection(Post.posts)
                            .doc(_doc.id).collection(Comment.comments).add({
                          Comment.colUI: FirebaseAuth.instance.currentUser!.uid,
                          Comment.colUN: FirebaseAuth.instance.currentUser!.displayName,
                          Comment.colMes: _message,
                          Comment.colTms: Timestamp.now(),
                        }).then((value) => print("comment added"))
                            .catchError((onError) => print(onError));
                        _controller.clear();
                        setState(() {
                          _message = "";
                        });
                      },
                      icon: Icon(Icons.arrow_forward_ios)
                  ),
                ),
              ],),
            )
          ],
        ),
      ),
    );
  }
}
