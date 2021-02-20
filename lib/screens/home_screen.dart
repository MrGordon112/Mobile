import 'dart:convert';

import 'package:RentACar/commons/displayDialog.dart';
import 'package:RentACar/provider/crud_notifier.dart';
import 'package:RentACar/widget/car_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:connectivity/connectivity.dart';

import '../car.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({this.title, Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int maxId = 0;
  var channel;
  ProgressDialog pr;
  var subscription;

  @override
  void initState() {
    final provider = Provider.of<CrudNotifier>(context, listen: false);
    provider.changeModified();
    super.initState();
    if (provider.isOnline) {
      channel = IOWebSocketChannel.connect("ws://10.0.2.2:4001")
        ..stream.listen((message) {
          print(message);
          provider.addCarLocally(Car.fromJson(jsonDecode(message)));
        });
    }

    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        if (channel is IOWebSocketChannel) {
          channel.sink.close();
          channel = null;
        }
        provider.changeInternetStatus(false);
      } else {
        if (!(channel is IOWebSocketChannel)) {
          channel = IOWebSocketChannel.connect("ws://10.0.2.2:4001")
            ..stream.listen((message) {
              print(message);
              provider.addCarLocally(Car.fromJson(jsonDecode(message)));
            });
        }
        provider.changeInternetStatus(true);
      }
    });
  }

  void addCar(BuildContext context, Map<String, String> inputData) {
    final provider = Provider.of<CrudNotifier>(context, listen: false);
    if (inputData == null) return;
    // print(inputData);
    provider.add(Car.fromJson(inputData));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrudNotifier>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: carList(context),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            // backgroundColor: Colors.black
            onPressed: provider.isOnline
                ? () async {
                    Map<String, String> inputData = await displayDialog(
                        context: context,
                        title: "Add a car",
                        buttonText: "ADD");
                    addCar(context, inputData);
                  }
                : null));
  }

  Widget carList(BuildContext context) {
    final provider = Provider.of<CrudNotifier>(context, listen: true);
    // print(provider.getCars.toString());
    var futureBuilder = FutureBuilder(
      future: provider.getCars(),
      builder: (context, carsSnap) {
        if (carsSnap.connectionState == ConnectionState.done) {
          if (carsSnap.data == null) return Container();
          return ListView.builder(
            itemCount: carsSnap.data.length,
            itemBuilder: (context, index) {
              return CarWidget(car: carsSnap.data[index]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    return futureBuilder;
  }

  @override
  void dispose() {
    if (channel is IOWebSocketChannel) channel?.sink?.close();
    subscription?.cancel();
    super.dispose();
  }
}
