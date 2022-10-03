import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';
import '../models/post_model.dart';
import 'chat_screen.dart';
import 'create_post_screen.dart';

class PostsScreen extends StatefulWidget {
  static const String id ="posts_screen";
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.purple[900],
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {
            final ImagePicker _picker = ImagePicker();
            await _picker.pickImage(source: ImageSource.gallery , imageQuality: 40).then((xFile) {
              if(xFile != null){
                File file = File(xFile.path);
                Navigator.of(context).pushNamed(CreatePostScreen.id,arguments: file);
              }
            });
          }, icon: const Icon(Icons.add)),
          IconButton(onPressed: (){
            context.read<AuthCubit>().signOut().then((value) =>
                Navigator.of(context).pushReplacementNamed(SignInScreen.id));
          }, icon: Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(Post.posts).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(child: Text("Error"));
          }
          if(snapshot.connectionState == ConnectionState.waiting
              || snapshot.connectionState == ConnectionState.none) {
            return const Center(child:CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index){
                QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                Post post = Post(id: doc[Post.colId],
                    userId: doc[Post.colUI],
                    userName: doc[Post.colUN],
                    timestamp: doc[Post.colTms],
                    imageUrl: doc[Post.colImg],
                    description: doc[Post.colDes]);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ChatScreen.id, arguments: post);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: FileImage(File(post.imageUrl)),//NetworkImage(doc[Post.colImg],),
                                fit: BoxFit.cover,
                          )),
                        ),
                        SizedBox(height: 5,),
                        Text(post.userName, style: Theme.of(context).textTheme.headline5,),
                        SizedBox(height: 5,),
                        Text(post.description, style: Theme.of(context).textTheme.headline5,),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
