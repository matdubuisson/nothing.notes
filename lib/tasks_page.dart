import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nothing_note/services/task_provider.dart';
import 'package:nothing_note/settings_page.dart';
import 'package:provider/provider.dart';
import 'add_task_screen.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Padding(
          padding: const EdgeInsets.only(right: 60),
          child: const Text('Tasks', style: TextStyle(fontSize: 40),),
        )),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ));
                    }, 
                icon: Icon(Icons.settings_rounded, size: 32,)
                ),
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: task.dueDate != null ? Text('Due: ${task.dueDate}') : null,
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                taskProvider.toggleTaskCompletion(task);
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_rounded, color: Colors.redAccent,),
              onPressed: () {
                taskProvider.deleteTask(task);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddTaskScreen(),
          ));
        },
        child: SvgPicture.asset(
                  'lib/icons/plus_icon.svg',
                  width: 35,
                  height: 35,
                  color: Colors.white,
                  ),
      ),
    );
  }
}
