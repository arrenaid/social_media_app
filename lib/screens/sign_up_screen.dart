import 'package:flutter/material.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String id ="sign_up_screen";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _username;
  late String _password;

  late final FocusNode _userFocusNode;
  late final FocusNode _passFocusNode;

  @override
  void initState() {
    _userFocusNode = FocusNode();
    _passFocusNode = FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    _userFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Social media app",
                    style:  Theme.of(context).textTheme.headline3),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/25),
                  //email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      labelText: "Enter email",
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(_userFocusNode);
                    },
                    onSaved: (value) {
                      _email = value!.trim();
                    },
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/25),
                  //username
                  TextFormField(
                    keyboardType: TextInputType.name,
                    focusNode: _userFocusNode,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      labelText: "Enter username",
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(_passFocusNode);
                    },
                    onSaved: (value) {
                      _username = value!.trim();
                    },
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Please enter your username";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/25),
                  //password
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    focusNode: _passFocusNode,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      labelText: "Enter password",
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_){
                    },
                    onSaved: (value) {
                      _password = value!.trim();
                    },
                    obscureText: true,
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Please enter your password";
                      }
                      if(value!.length < 5){
                        return "Please enter longer password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/25),
                  TextButton(onPressed: (){
                    //Todo: submit form
                  }, child: const Text("Sign Up")),
                  TextButton(onPressed: (){
                    Navigator.of(context).pushReplacementNamed(SignInScreen.id);
                  }, child: const Text("Sign In instead"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
