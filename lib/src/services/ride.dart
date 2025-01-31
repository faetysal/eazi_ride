import 'dart:convert';

import 'package:eazi_ride/src/models/car.dart';
import 'package:eazi_ride/src/models/driver.dart';
import 'package:get/get.dart';

import 'http.dart';

class RideService extends GetxController {
  final Driver driver1 = Driver(
    name: 'George Jacob',
    photo: 'avatar-3.jpg',
    rating: 4.8,
    car: Car(
      name: 'Toyota Camry',
      photo: 'camry.png',
      plate: 'LSR 123 AB',
      color: 'Silver',
      type: CarType.sedan
    )
  );

  final Driver driver2 = Driver(
    name: 'Sue Pirnova',
    photo: 'avatar-5.jpg',
    rating: 4.5,
    car: Car(
      name: 'Lexus RX 350',
      photo: 'rx350.png',
      plate: 'LND 456 CD',
      color: 'Blue',
      type: CarType.suv,
      category: CarCategory.executive
    )
  );

  final Driver driver3 = Driver(
    name: 'Poly Nomial',
    photo: 'avatar-1.jpg',
    rating: 4,
    car: Car(
      name: 'Suzuki S-Presso',
      photo: 'suzuki.png',
      plate: 'FST 789 EF',
      color: 'Orange',
      type: CarType.micro,
      category: CarCategory.economy
    )
  );

  final Driver driver4 = Driver(
    name: 'Joe Bloggs',
    photo: 'avatar-2.jpg',
    rating: 3,
    car: Car(
      name: 'Toyota Corolla',
      photo: 'corolla.png',
      plate: 'LSD 012 GH',
      color: 'Silver',
      type: CarType.sedan
    )
  );

  final Driver driver5 = Driver(
    name: 'Jane Doe',
    photo: 'avatar-4.jpg',
    rating: 5,
    car: Car(
      name: 'Hyundai',
      photo: 'hyundai.png',
      plate: 'AKD 345 IJ',
      color: 'White',
      type: CarType.coupe,
      category: CarCategory.economy
    )
  );

  List<Driver> drivers = [];

  @override
  void onInit() {
    super.onInit();

    drivers.add(driver1);
    drivers.add(driver2);
    drivers.add(driver3);
    drivers.add(driver4);
    drivers.add(driver5);
  }

  Future<List> getLocation(String query, {String? token}) async {
    final Http http = Get.find();

    const url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    const apiKey = String.fromEnvironment('GOOGLE_API_KEY');
    // final type = '(region)';
    final request = '$url?input=$query&components=country:ng&key=$apiKey&sessiontoken=$token';

    final response = await http.get(request);
    if (response.statusCode == 200) {
      return response.body['predictions'];
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<Map> getPlaceDetails(String id) async {
    final Http http = Get.find();

    const url = 'https://maps.googleapis.com/maps/api/place/details/json';
    const apiKey = String.fromEnvironment('GOOGLE_API_KEY');
    final request = '$url?placeid=$id&key=$apiKey';

    final response = await http.get(request);
    if (response.statusCode == 200) {
      return response.body['result']['geometry']['location'];
    } else {
      throw Exception('Failed to load place details');
    }
  }

}