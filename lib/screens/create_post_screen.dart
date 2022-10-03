import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  static const String id = "create_post_screen";
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late String _description ;

  _submit({required File image}) async {
    late var downloadURL;
    FocusScope.of(context).unfocus();
    if(_description.trim().isNotEmpty) {

        // firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(bucket: "gs://sotial-media-test-app.appspot.com");
        // final storageRef = storage.ref();
        // storageRef.child("images/${UniqueKey().toString()}.jpg");//${UniqueKey().toString()}
        // try{
        //   await storageRef.putFile(image);
        // } on FirebaseException catch (e) {
        //   print("--------------------$e---------------------");
        //   //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("image not loading. error: $e")));
        // }
        // try {
        //   downloadURL = await storageRef.getDownloadURL();
        // }on FirebaseException catch (e) {
        //   print("=======--------$e---------------------");
        //   //ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, duration: Duration(seconds: 5),content: Text("downloadUgl get. error: $e")));
        // }

        // await storage.ref("images/${UniqueKey().toString()}.jpg")
        //     .putFile(image)
        //     .then((taskSnap) async {
        //   downloadURL = await taskSnap.ref.getDownloadURL();
        // });
        print("start");
        try {
          FirebaseFirestore.instance.collection(Post.posts).add({
            Post.colDes: _description,
            Post.colTms: Timestamp.now(),
            Post.colUI: FirebaseAuth.instance.currentUser!.uid,
            Post.colUN: FirebaseAuth.instance.currentUser!.displayName,
            Post.colImg: image.path,  //downloadURL
          }).then((value) => value.update({Post.colId: value.id}));
        }on FirebaseException catch (e) {
          print("===============$e---------------------");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, duration: Duration(seconds: 5),content: Text("post not loading. error: $e")));
        }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    File imageFile = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create post")),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width/1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: FileImage(imageFile),
                          fit: BoxFit.cover)),
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Enter a decoration",),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(150),
                  ],
                  onChanged: (value) {
                    _description = value;
                  },
                  onEditingComplete: (){
                    _submit(image: imageFile);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
