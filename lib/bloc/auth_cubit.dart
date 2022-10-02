import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  static const String collectionName = "users";
  static const String colUserId = "userID";
  static const String colUsername = "username";
  static const String colEmail = "email";

  Future<void> signIn({
    required String email,
    required String pass,
  }) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      auth.signInWithEmailAndPassword(email: email, password: pass);
      emit(AuthSignedIn());
    }on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        emit(AuthError(message: e.toString()));
        print('Wrong password provided for that user.');
      } else if (e.code == 'user-not-found') {
        emit(AuthError(message: e.toString()));
        print('User not fount.');
      }
    } catch(error){
      print(error);
      emit(AuthError(message: "An error has occurred: $error"));
    }
  }

  Future<void> signUp({
    required String email,
    required String user,
    required String pass,
  }) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      FirebaseFirestore.instance.collection(collectionName).doc(userCredential.user!.uid).set({
        colUserId: userCredential.user!.uid,
        colUsername: user,
        colEmail: email
      });
      userCredential.user!.updateDisplayName(user);
      emit(AuthSignedUp());
    }  on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthError(message: e.toString()));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(AuthError(message: e.toString()));
        print('The account already exists for that email.');
      }
    } catch(e){
      emit(AuthError(message: e.toString()));
      print(e);
    }
  }
  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}
