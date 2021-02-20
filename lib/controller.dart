import 'package:RentACar/db_repository.dart';
import 'package:RentACar/repository.dart';

import 'car.dart';

class Controller {
  final Repository repository;

  Controller({this.repository});

  // void add(Car car) {
  //   repository.add(car);
  // }

  // void delete(Car car) {
  //   repository.delete(car.id);
  // }

  // void update(Car oldCar, Car car) {
  //   repository.update(oldCar, car);
  // }

  Future<List<Car>> getAll() async {
    return repository.getCars();
  }
}
