import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // get collection of notes
  final CollectionReference notes =
  FirebaseFirestore.instance.collection('notes');

  // ADD: add new notes
  Future<void> addNote(String userId,String note) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await notes.doc(userId).collection('notes').add({
        "note": note,
        "timestamp": Timestamp.now(),
        "userId": userId,
      });
    }
  }

  // GET: get all notes
Stream<QuerySnapshot> getNotesStream() {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    final notesStream = notes.doc(userId).collection('notes').orderBy("timestamp", descending: true).snapshots();
    return notesStream;
  } else {
    return Stream.empty(); // Return an empty stream
  }
}

 Future<void> updateNote(String docID, String userId, String newNote) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
  return notes.doc(userId).collection('notes').doc(docID).update({
    "note": newNote,
    "timestamp": Timestamp.now(),
    "userId": userId,
   }
  );
 }

  // DELETE: delete notes given a doc id
  Future<void> deleteNote(String docID, String userId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
  return notes.doc(userId).collection('notes').doc(docID).delete();
 }

 // get collection of todos
  final CollectionReference todos =
  FirebaseFirestore.instance.collection('todos');

  // ADD: add new todo
  Future<void> addTodo(String userId,String todo) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await todos.doc(userId).collection('todos').add({
        "todo": todo,
        "timestamp": Timestamp.now(),
        "userId": userId,
      });
    }
  }

  // GET: get all todos
Stream<QuerySnapshot> getTodoStream() {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    final todosStream = todos.doc(userId).collection('todos').orderBy("timestamp", descending: true).snapshots();
    return todosStream;
  } else {
    return Stream.empty(); // Return an empty stream
  }
}

 Future<void> updateTodo(String docID, String userId, String newTodo) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
  return todos.doc(userId).collection('todos').doc(docID).update({
    "todo": newTodo,
    "timestamp": Timestamp.now(),
    "userId": userId,
   }
  );
 }

  // DELETE: delete todos given a doc id
  Future<void> deleteTodo(String docID, String userId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
  return todos.doc(userId).collection('todos').doc(docID).delete();
 }
}