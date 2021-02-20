import 'dart:convert';
import 'dart:math';

import 'package:RentACar/car.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db_repository.dart';

var logger = Logger();

class Repository {
  var logger = Logger();
  List<Car> localList = new List();
  String baseUrl = 'http://10.0.2.2:4001/';
  Map<String, String> headers = {"Content-type": "application/json"};
  DBRepository dbRepo = DBRepository();
  int carId;

  Future<bool> checkIfHaveCar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("user");
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<dynamic> add(Car car) async {
    logger.i("Server: adding car to server");
    Response response = await post(
      baseUrl + 'car',
      headers: headers,
      body: json.encode(car.toJson()),
    );
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Car carNew = new Car.fromJson(body);
      logger.i("Server: added car to server");
      return carNew;
    } else {
      String error = json.decode(response.body)["text"];
      logger.e("Server: error on adding $error");
      return error;
    }
  }

  Future<String> addCarNoMetterWhat(Car car) async {
    bool isInternetAvailable = await isConnectedToInternet();
    localList.add(car);
    if (isInternetAvailable) {
      return addEvery();
    } else {
      dbRepo.add(car);
      return "";
    }
  }

  Future<Car> updateCar(Car car) async {
    logger.i("Server: Update car, id = " + car.id.toString());
    Response response = await put(baseUrl + "car/" + car.id.toString(),
        headers: headers, body: json.encode(car.toJson()));

    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      Car carNew = new Car.fromJson(body);
      return carNew;
    } else {
      return null;
    }
  }

  Future<bool> deleteCar(Car car) async {
    logger.i("Server: Delete car, id = " + car.id.toString());
    Response response = await delete(baseUrl + "car/" + car.id.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Car>>   getCars() async {
    var rand = new Random();
    logger.i("Server: Get all cars");
    bool isInternetAvailable = await isConnectedToInternet();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("car")) {
      prefs.setInt("car", rand.nextInt(100));
    }
    carId = prefs.getInt("car");
    if (localList.length > 0) {
      await addEvery();
    }
    List<Car> toReturn = [];
    if (isInternetAvailable) {
      Response response = await get(baseUrl + "cars");
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        toReturn = body.map((f) => Car.fromJson(f)).toList();
      } else {
        logger.e("Server: Error in getting items");
        return [];
      }
      logger.i("exit with: " + toReturn.map((f) => f.toJson()).toString());
      return toReturn;
    } else {
      return dbRepo.getAll();
    }
  }

  Future<String> addEvery() async {
    var errors = "";
    for (var i in localList) {
      dynamic result = await add(i);
      if (result is String) errors += result;
    }
    localList.clear();
    return errors;
  }
}
