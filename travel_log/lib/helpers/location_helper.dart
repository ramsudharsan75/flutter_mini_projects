import 'dart:convert';

import 'package:http/http.dart' as http;

const googleApiKey = '';

class LocationHelper {
  static String generateLocationPreviewImage(
      {required double lat, required double long}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=$googleApiKey';
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final url = Uri.https('maps.googleapis.com',
        'maps/api/geocode/json?latlng=$lat,$long&key=$googleApiKey');
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
