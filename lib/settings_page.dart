import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nothing_note/components/login_or_register.dart';
import 'package:nothing_note/login_page.dart';
import 'package:nothing_note/services/auth.dart';
import 'package:nothing_note/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://tinted-seaplane-cb4.notion.site/12f93fc8858b80988e44c2bb258063f0?pvs=105');

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  // logout user
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthPage()));
  }

  // launch url
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
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
            onPressed: () {
              signOut();
            }, 
            child: Text(
              "Log out", 
              style: TextStyle(
                color: Colors.redAccent,),
              ),
            ),

            GestureDetector(
              onTap: () {
                _launchUrl();
              },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
            ),
        ],
      ),
    );
  }
}