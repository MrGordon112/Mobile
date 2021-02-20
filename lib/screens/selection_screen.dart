import 'package:flutter/material.dart';

import '../car.dart';

class SelectionScreen extends StatefulWidget {
  final String title;
  final String buttonText;
  final Car car;
  const SelectionScreen(
      {Key key, @required this.title, @required this.buttonText, this.car})
      : super(key: key);

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  Map<String, String> inputData;

  @override
  void initState() {
    super.initState();
    inputData = widget.car != null
        ? {
            "license": widget.car.license,
            "model": widget.car.statuses,
            "drivers": widget.car.drivers.toString(),
            "colors": widget.car.colors.toString(),
            "seats":widget.car.seats.toString(),
            "cargo":widget.car.cargo.toString()
          }
        : {
            "license": "",
            "model": "",
            "drivers": "",
            "colors": "",
            "seats":"",
            "cargo":""
          };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: TextFormField(
                autofocus: true,
                initialValue: inputData['license'],
                decoration: new InputDecoration(labelText: 'license'),
                onChanged: (value) {
                  inputData['names'] = value;
                },
              ),
            ),
            TextFormField(
              initialValue: inputData['statuses'],
              decoration:
                  new InputDecoration(labelText: 'statuses', hintText: 'statuses'),
              onChanged: (value) {
                inputData['statuses'] = value;
              },
            ),
            TextFormField(
              initialValue: inputData['drivers'],
              decoration:
                  new InputDecoration(labelText: 'drivers', hintText: 'drivers'),
              onChanged: (value) {
                inputData['drivers'] = value;
              },
            ),
            TextFormField(
              initialValue: inputData['colors'],
              decoration:
                  new InputDecoration(labelText: 'colors', hintText: 'colors'),
              onChanged: (value) {
                inputData['colors'] = value;
              },
            ),
            TextFormField(
              initialValue: inputData['seats'],
              decoration:
              new InputDecoration(labelText: 'seats', hintText: 'seats'),
              onChanged: (value) {
                inputData['seats'] = value;
              },
            ),
            TextFormField(
              initialValue: inputData['cargo'],
              decoration:
              new InputDecoration(labelText: 'cargo', hintText: 'cargo'),
              onChanged: (value) {
                inputData['cargo'] = value;
              },
            ),
            Row(children: [
              new FlatButton(
                child: new Text(widget.buttonText),
                onPressed: () {
                  Navigator.of(context).pop(inputData);
                },
              ),
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ])
          ],
        ),
      ),
    );
  }
}
