import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:flutter_todo_app/pages/home_page.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final locator = GetIt.instance;
void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');
  for (var task in taskBox.values) {
    if (task.createdAt.day != DateTime.now().day) {
      taskBox.delete(task.id);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await setupHive();
  setup();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.grey.shade300,
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
      ),
      home: const HomePage(),
    );
  }
}
