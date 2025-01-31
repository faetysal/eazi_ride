import 'dart:convert';

import 'package:get/get.dart';

import 'http.dart';

class RideService extends GetxController {
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