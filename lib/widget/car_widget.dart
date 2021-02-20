import 'package:RentACar/commons/displayDialog.dart';
import 'package:RentACar/provider/crud_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../car.dart';

class CarWidget extends StatelessWidget {
  final Car car;

  CarWidget({Key key, this.car}) : super(key: key);

  void deleteCar(BuildContext context, Car car) {
    final provider = Provider.of<CrudNotifier>(context, listen: false);
    provider.delete(car);
  }

  void updateCar(BuildContext context, Car car) async {
    Map<String, String> inputData = await displayDialog(
        context: context, title: "Update car", buttonText: "Update", car: car);
    if (inputData == null) return;
    inputData['id'] = car.id.toString();
    // print(inputData);
    Car newCar = Car.fromJson(inputData);
    // print(newCar.toJson());
    final provider = Provider.of<CrudNotifier>(context, listen: false);
    provider.update(car, newCar);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrudNotifier>(context, listen: true);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: CarDetails(car: car),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Update',
          color: Colors.blue,
          icon: Icons.update,
          onTap: () => updateCar(context, car),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: provider.isOnline ? () => deleteCar(context, car) : null,
        ),
      ],
    );
  }
}

class CarDetails extends StatelessWidget {
  final Car car;
  const CarDetails({Key key, @required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        title: ListTile(
          leading: CircleAvatar(
            child: Text(car.id.toString()),
          ),
          title: Text(car.license),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[Text("statuses: "), Text(car.statuses)],
                ),
                Row(
                  children: <Widget>[Text("drivers: "), Text(car.drivers.toString())],
                ),
                Row(
                  children: <Widget>[
                    Text("colors: "),
                    Text(car.colors.toString())
                  ],
                ), Row(
                  children: <Widget>[
                    Text("seats: "),
                    Text(car.seats.toString())
                  ],
                ), Row(
                  children: <Widget>[
                    Text("cargo: "),
                    Text(car.cargo.toString())
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
