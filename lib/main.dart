import 'package:RentACar/db_repository.dart';
import 'package:RentACar/provider/crud_notifier.dart';
import 'package:RentACar/repository.dart';
import 'package:RentACar/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'db_creator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBCreator().initDB();

  Repository repository = new Repository();
  Controller controller = new Controller(repository: repository);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CrudNotifier>.value(
        value: CrudNotifier(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Taxi CRUD'),
    );
  }
}
