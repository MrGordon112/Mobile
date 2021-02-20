import 'package:flutter/material.dart';

import '../car.dart';

Future<Map<String, String>> displayDialog(
    {BuildContext context, String title, String buttonText, Car car}) async {
  Map<String, String> inputData = car != null
      ? {
          "id": car.id.toString(),
          "license": car.license,
          "statuses": car.statuses,
          "drivers": car.drivers,
          "colors": car.colors,
          "seats":car.seats.toString(),
          "cargo":car.cargo.toString()
        }
      : {
          "id": "-1",
          "name": "",
          "statuses": "",
          "drivers": "",
          "colors": "",
          "seats":"",
          "cargo":"",
        };
  return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: TextFormField(
                  autofocus: true,
                  initialValue: inputData['names'],
                  decoration: new InputDecoration(labelText: 'names'),
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
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(buttonText),
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
          ],
        );
      });
}
