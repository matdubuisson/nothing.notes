import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nothing_note/components/helper_functions.dart';
import 'package:nothing_note/components/my_button.dart';
import 'package:nothing_note/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap
    });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // login method
  void login () async {
    // show loading circle
    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
   );

   // try sign in
   try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: pwController.text
    );

    // pop loading circle
    if (context.mounted) Navigator.pop(context);
   }

   // display any errors
   on FirebaseAuthException catch (e) {
    // pop loading circle
    Navigator.pop(context);
    displayMessageToUser(e.code, context);
   }
  }

  // google sign in
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // user cancels google sign in
    if (googleUser == null) return;
    
    // obtain auth details from request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // sign in with credential
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 115),
          child: ListView(
            children: [
              Column(
              children: [
                // logo
                Center(child: Icon(Icons.lock_open_rounded, size: 72,)),
            
                const SizedBox(height: 25,),
            
                // app name
                Text("L O G I N", style: TextStyle(fontSize: 20),),
            
                const SizedBox(height: 50,),
            
                // email textfield
                MyTextfield(
                  hintText: "Email", 
                  controller: emailController, 
                  obscureText: false
                  ),
            
                  const SizedBox(height: 10,),
            
                // password textfield
                MyTextfield(hintText: "Password", 
                controller: pwController,
                obscureText: true),
            
                const SizedBox(height: 10,),
            
                // forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?", 
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                  ],
                ),
            
                const SizedBox(height: 25,),
            
                // sign in button
                MyButton(text: "Login", onTap: login),
            
                const SizedBox(height: 25,),
            
            
                // dont have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,),
                      ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Register Here!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,),
                        ),
                    ),
                  ],
                ),
              ]
            ),
            ]
          ),
        ),
      ),
    );
  }
}