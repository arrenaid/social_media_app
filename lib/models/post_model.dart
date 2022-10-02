import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String id;
  final String userId;
  final String userName;
  final Timestamp timestamp;
  final String imageUrl;
  final String description;
  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.imageUrl,
    required this.description
  });
  static const String posts = "posts";
  static const String colId = "postID";
  static const String colUI = "userID";
  static const String colUN = "userName";
  static const String colTms = "timestamp";
  static const String colImg = "imageUrl";
  static const String colDes = "description";
}