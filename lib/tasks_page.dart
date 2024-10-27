import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nothing_note/services/firestore.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  // logout user

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  // open a Textbox to add a note
  void openTodoBox({String? docID}) {
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
      ), 
      backgroundColor: Theme.of(context).colorScheme.secondary,
      actions: [

        // button to save
        ElevatedButton(
          onPressed: () {

            // cancel button
            TextButton(onPressed: () => Navigator.of(context).pop(), 
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(
              "Cancel", 
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary),
                ),
               );

            // add a new note
            if (docID == null) {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                firestoreService.addTodo(userId, textController.text);
              }
            }

            // clear the text controller
            textController.clear();

            // close the box
            Navigator.pop(context);
          }, 
          child: Text("Add", style: TextStyle(fontFamily: "Nothing", color: Theme.of(context).colorScheme.inversePrimary,),),
          ),
      ],
      ));
}

bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text(
              "Tasks", 
              style: TextStyle(
                fontFamily: "Nothing", 
                fontWeight: FontWeight.w500, 
                fontSize: 40),
                ),
            actions: [

              // logout button
              IconButton(
                onPressed: logout, 
                icon: Icon(
                  Icons.logout_rounded, 
                  color: Colors.white, 
                  size: 40,
                  ),
                 ),

            ],
           ),

           // add a new note
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: openTodoBox, 
        child: SvgPicture.asset(
                  'lib/icons/plus_icon.svg',
                  width: 35,
                  height: 35,
                  color: Colors.white,
                  ),
        ),


        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getTodoStream(),
          builder: (context, snapshot) {

            // if we have data, get all the docs
            if (snapshot.hasData) {
              List todosList = snapshot.data!.docs;

              // display as a list
              return ListView.builder(
                itemCount: todosList.length,
                itemBuilder: (context, index) {
                  
                // get each individual doc
                DocumentSnapshot document = todosList[index];
                String docID = document.id;

                // get note from each doc
                Map<String, dynamic> data =
                     document.data() as Map<String, dynamic>;
                String todoText = data ['todo'];

                // display as a list tile
                return ListTile(
                  title: Text(todoText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // checkbox
                       Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                          // Save the checkbox value to Firebase
                          final userId = FirebaseAuth.instance.currentUser?.uid;
                            FirebaseFirestore.instance.collection("todos").doc(userId).collection('todos').doc(docID).update({
                              'isChecked': true,
                          });
                        },
                      ),

                      // delete button
                      IconButton(onPressed: () => firestoreService.deleteTodo(docID, userId!), 
                      icon: SvgPicture.asset(
                        'lib/icons/delete_icon.svg',
                        width: 40,
                        height: 40,
                        color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),

                );
              },
             );
            }

            else {
              return const Text("No tasks...");
            }
          }
        ),
    );
  }
}