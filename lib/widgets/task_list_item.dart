import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({Key? key, required this.task}) : super(key: key);
  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black12.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0XFFE5E5E5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            // width: 40,
            // height: 40,
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: widget.task.isCompleted ? Colors.green : Colors.grey, width: 0.8),
                shape: BoxShape.circle),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (yeniDeger) {
                  if (yeniDeger.length > 3) {
                    widget.task.name = yeniDeger;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: TextStyle(
            fontSize: 14,
            color: widget.task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
      ),
    );
  }
}
