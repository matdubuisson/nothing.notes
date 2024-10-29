import 'package:flutter/material.dart';
import 'package:nothing_note/components/my_textfield.dart';
import 'package:nothing_note/components/task.dart';
import 'package:nothing_note/services/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskController = TextEditingController();
  DateTime? _selectedDate;

  void _saveTask() {
    if (_taskController.text.isEmpty) return;

    final newTask = Task(
      id: const Uuid().v4(),
      title: _taskController.text,
      dueDate: _selectedDate,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
    Navigator.of(context).pop();
  }

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTextfield(hintText: "Task Title", controller: _taskController, obscureText: false),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Due Date'
                        : 'Due: ${_selectedDate.toString().substring(0, 10)}',
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _pickDueDate,
                  child: Text('Pick Due Date', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: _saveTask,
              child: Text('Save Task', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
