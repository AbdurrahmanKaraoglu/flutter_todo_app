// ignore_for_file: implementation_imports

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/helper/translations_helper.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:flutter_todo_app/widgets/custom_search_delegate.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: const Text(
            'title',
            style: TextStyle(
              color: Colors.black,
            ),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchPage();
            },
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var _oankiListeElemani = _allTasks[index];
                return Dismissible(
                  key: Key(_oankiListeElemani.id),
                  onDismissed: (direction) {
                    _allTasks.removeAt(index);
                    _localStorage.deleteTask(task: _oankiListeElemani);
                    setState(() {});
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
              itemCount: _allTasks.length,
            )
          : Center(
              child: const Text('empty_task_list').tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      // backgroundColor: Colors.transparent,
      // barrierColor: Colors.transparent,
      // elevation: 0,
      context: context,
      builder: (context) {
        // return Container(
        //   margin: const EdgeInsets.only(right: 10, left: 10),
        //   height: 400,
        //   decoration: const BoxDecoration(
        //     color: Colors.blue,
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //     ),
        //   ),
        // );
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(hintText: 'add_new_task'.tr(), border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    context,
                    locale: TranslationsHelper.getDeviceLanguage(context),
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev = Task.create(name: value, createdAt: time);
                      _allTasks.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTasks();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(context: context, delegate: CustomSearchDelegate(allTask: _allTasks));
    _getAllTaskFromDb();
  }
}
