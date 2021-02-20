import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Car extends Equatable {
  final int id;
  final String license;
  final String statuses;
  final String drivers;
  final String colors;
  final int seats;
  final int cargo;

  Car({this.license, this.statuses, this.drivers, this.colors, this.id ,this.seats,this.cargo});

  @override
  List<Object> get props => [id, license];

  Car.fromJson(Map<String, dynamic> json)
      : license = json['license'] ?? '',
        statuses = json['statuses'] ?? '',
        id = int.parse(json['id'].toString() ?? '-1') ?? -1,
        drivers = json['drivers'] ?? '',
        colors = json['colors'] ?? '',
        seats=int.parse(json['seats'].toString()),
        cargo=int.parse(json['cargo'].toString());



  Map<String, dynamic> toJson() => {
        'id': id,
        'license': license,
        'statuses': statuses,
        'drivers': drivers,
        'colors': colors,
        'seats':seats,
        'cargo':cargo
      };
}
