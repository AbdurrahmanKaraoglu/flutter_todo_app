// ignore_for_file: implementation_imports

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  late final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query.isEmpty ? null : query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList =
        allTask.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var _oankiListeElemani = filteredList[index];
              return Dismissible(
                key: Key(_oankiListeElemani.id),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: _oankiListeElemani);
                },
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('delete_task', style: TextStyle(color: Colors.red)).tr(),
                  ],
                ),
                child: TaskItem(task: _oankiListeElemani),
              );
            },
            itemCount: filteredList.length,
          )
        : Center(
            child: const Text(
              'notfound_task',
              style: TextStyle(fontSize: 20),
            ).tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
