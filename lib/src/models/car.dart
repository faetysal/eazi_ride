import 'package:flutter/material.dart';

class Car {
  String name;
  String photo;
  String plate;
  CarType type;
  CarCategory category;
  String color;


  Car({
    this.name = '',
    this.photo = '',
    this.plate = '',
    this.type = CarType.sedan,
    this.category = CarCategory.regular,
    this.color = ''
  });
}

enum CarType {
  sedan,
  coupe,
  suv,
  micro
}

enum CarCategory {
  regular,
  executive,
  economy
}