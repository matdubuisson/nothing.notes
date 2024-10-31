import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nothing_note/theme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // logout user

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(25),
                padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Light Mode",
                  ),
                Switch(
                  value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode, 
                  onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                  ),
              ],
            ),
          ),

          Divider(
            height: 20,
            indent: 45,
            endIndent: 45,
          ),
          TextButton(
            onPressed: logout, 
            child: Text(
              "Log out", 
              style: TextStyle(
                color: Colors.redAccent,),
              ),
            ),
            
            TextButton(onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete your Account?'),
                    content: const Text(
              '''If you select Delete we will delete your account on our server.

              Your app data will also be deleted and you won't be able to retrieve it.

              Since this is a security-sensitive operation, you eventually are asked to login before your account can be deleted.'''),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.redAccent),),
                        onPressed: () {
                          Future<void> deleteUserAccount() async {
                              try {
                              await FirebaseAuth.instance.currentUser!.delete();
                              } catch (e) {
                              print(e);
                              }
                            }
                        },
                      ),
                    ],
                  );
                },
              );
             }, 
              child: Text("Delete Account", style: TextStyle(color: Colors.redAccent),),)
        ],
      ),
    );
  }
}