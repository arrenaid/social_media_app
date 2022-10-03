import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String userName;
  String userId;
  String message;
  Timestamp timestamp;
  Comment({
   required this.userName,
   required this.userId,
   required this.timestamp,
   required this.message
  });
  static const String colUI ="userID";
  static const String colUN ="userName";
  static const String colMes ="message";
  static const String colTms ="timeStamp";
  static const String comments ="comments";
}