import 'package:RentACar/controller.dart';
import 'package:RentACar/db_repository.dart';
import 'package:RentACar/repository.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../car.dart';

class CrudNotifier extends ChangeNotifier {
  Repository repository = Repository();
  List<Car> cars = [];
  bool isOnline = true;
  bool modified = false;
  bool fromServer = true;
  var logger = Logger();
  DBRepository bdRepo = DBRepository();

  Future<List<Car>> getCars() async {
    if (cars.isEmpty) {
      if (isOnline)
        cars = await repository.getCars();
      else
        cars = await bdRepo.getAll();
    }
    return cars;
  }

  void changeModified() {
    modified = true;
  }

  void addCarLocally(Car car) {
    bdRepo.add(car);
    cars.add(car);
    notifyListeners();
  }

  void changeInternetStatus(bool userIsOnline) {
    isOnline = userIsOnline;
    notifyListeners();
  }

  Future<Car> update(Car oldCar, Car car) async {
    final Car newCar = await repository.updateCar(car);
    if (newCar != null) {
      int pos = cars.lastIndexOf(oldCar);
      await bdRepo.update(car);
      deleteLocalCar(car.id);
      addAtPosition(car, pos);
      deleteLocalCar(car.id);
    }
    notifyListeners();
    return newCar;
  }

  void deleteLocalCar(int id) {
    Car car = findById(id);
    cars.remove(car);
  }

  Car findById(int id) {
    for (int i = 0; i < cars.length; ++i) if (cars[i].id == id) return cars[i];
    return null;
  }

  void addAtPosition(Car car, int position) {
    cars.insert(position, car);
  }

  void refresh() {
    fromServer = true;
    notifyListeners();
  }

  Future<String> add(Car car) async {
    String added = await repository.addCarNoMetterWhat(car);
    notifyListeners();
    return added;
  }

  Future<bool> delete(Car car) async {
    final bool hasCars = await repository.deleteCar(car);
    if (hasCars) {
      await bdRepo.delete(car);
      cars.remove(car);
    }
    notifyListeners();
    return hasCars;
  }
}
