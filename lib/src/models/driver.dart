import 'car.dart';

class Driver {
  String name;
  String photo;
  double rating;
  Car? car;
  DriverStatus status;

  Driver({
    this.name = '',
    this.photo = '',
    this.rating = 0,
    this.car,
    this.status = DriverStatus.available
  });
}

enum DriverStatus {
  available,
  unavailable,
  busy
}