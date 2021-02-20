import 'package:RentACar/car.dart';
import 'package:RentACar/db_creator.dart';
import 'package:logger/logger.dart';

class DBRepository {
  var logger = Logger();

  Future<Car> add(Car car) async {
    logger.i("trying to add a car to db");
    final sql = '''INSERT INTO ${DBCreator.carTable}
    (
      ${DBCreator.license},
      ${DBCreator.statuses},
      ${DBCreator.drivers},
      ${DBCreator.colors}
        ${DBCreator.seats},
      ${DBCreator.cargo}
      
    )
    VALUES
    (
      "${car.license}",
      "${car.statuses}",
      ${car.drivers},
      ${car.colors}
       ${car.seats},
      ${car.cargo}
    )
    ''';
    try {
      await db.rawInsert(sql);
      logger.i("DB: added ${car.id.toString()}");
    } catch (e) {
      logger.e(e);
    }

    return car;
  }

  Future<List<Car>> getAll() async {
    final sql = '''SELECT * FROM ${DBCreator.carTable}''';
    final data = await db.rawQuery(sql);
    List<Car> list = List();
    for (var elem in data) {
      Car car = Car.fromJson(elem);
      list.add(car);
      logger.d(elem);
    }
    logger.i("DB: get All cars");
    return list;
  }

  Future<void> deleteAll() async {
    final sql = '''DELETE FROM ${DBCreator.carTable}''';
    await db.rawDelete(sql);
    logger.i("DB: deleted all cars");
  }

  Future<void> delete(Car car) async {
    final sql = '''DELETE FROM ${DBCreator.carTable}
        WHERE ${DBCreator.id} == ${car.id}''';
    await db.rawUpdate(sql);
    logger.i("DB: deleted a car");
  }

  Future<void> update(Car car) async {
    final sql = '''UPDATE ${DBCreator.carTable}
        SET ${DBCreator.license} = "${car.license}",
            ${DBCreator.statuses} = "${car.statuses}",
            ${DBCreator.drivers} = ${car.drivers},
            ${DBCreator.colors} = ${car.colors}
             ${DBCreator.seats} = ${car.seats},
            ${DBCreator.cargo} = ${car.cargo}
        WHERE ${DBCreator.id} == ${car.id}''';
    logger.d(sql);
    int number = await db.rawUpdate(sql);

    logger.i("DB: update a car - $number");
  }
}
