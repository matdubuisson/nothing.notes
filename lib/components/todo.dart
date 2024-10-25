/*

TO DO MODEL

This is a todo object

---------------------------------------------------------------------------------

It has these properties:

- id
- title
- isCompleted

---------------------------------------------------------------------------------

It has these methods:

- toggle completion on & off

*/

class Todo {
  final int id;
  final String text;
  bool isCompleted;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false, // initially, todo is incomplete
  });

  Todo toggleCompletion() {
    return Todo(
      id: id,
      text: text,
      isCompleted: !isCompleted,
    );
  }

}