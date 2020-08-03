import 'dart:async';
import 'dart:convert';
import 'data/error.dart';
import 'data/place_response.dart';
import 'data/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as x;
import 'package:location_permissions/location_permissions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

class PlacesSearchMapSample extends StatefulWidget {
  final String keyword;

  PlacesSearchMapSample(this.keyword);

  @override
  State<PlacesSearchMapSample> createState() {
    return _PlacesSearchMapSample();
  }
}

bool noServiceRequestMade = true, noPermissionRequestMade = true;

class _PlacesSearchMapSample extends State<PlacesSearchMapSample> {
  static const _API_KEY = 'AIzaSyChM89_AuTn9M7jHHI2NvWMuBlpAMPyT2c';
  static const baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  List<Marker> markers = <Marker>[];
  Error error;
  List<Result> places;
  String keyword;

  GoogleMapController mapController;
  final location = x.Location();

  requestService([bool bypass]) async {
    if (noServiceRequestMade) {
      noServiceRequestMade = false;
      if (bypass ||
          await LocationPermissions().checkPermissionStatus() !=
              PermissionStatus.granted) {
        await location.requestService();
      }
    }
  }

  requestPermission([bool bypass]) async {
    if (noPermissionRequestMade) {
      noPermissionRequestMade = false;
      if (bypass ||
          await LocationPermissions().checkServiceStatus() ==
              ServiceStatus.disabled) {
        await location.requestPermission();
        if (await LocationPermissions().checkServiceStatus() ==
            ServiceStatus.disabled) {
          await requestService(true);
        }
      }
    }
  }

  Future<LatLng> getUserLocation() async {
    try {
      if (await LocationPermissions().checkPermissionStatus() !=
          PermissionStatus.granted) {
        await requestPermission(true);
      } else if (await LocationPermissions().checkServiceStatus() ==
          ServiceStatus.disabled) {
        await requestService(true);
      }
      final Position currentLocation = await Geolocator().getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.medium);
      return LatLng(currentLocation.latitude, currentLocation.longitude);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> centreCamera() async {
    final LatLng center = await getUserLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: center ?? LatLng(0, 0),
      zoom: 15.0,
    )));
  }

  static const IconData police =
      const IconData(0xe82b, fontFamily: 'app_icons');

  Widget sampleWidgetList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              LatLng location = await getUserLocation();
              searchNearby(location.latitude, location.longitude, '');
            },
            label: Text(
              'Open Now',
            ),
            icon: Icon(Icons.watch_later),
            heroTag: null,
            backgroundColor: Color(0xFFEC8B80),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              LatLng location = await getUserLocation();
              searchNearby(location.latitude, location.longitude, 'hospital');
            },
            label: Text('Hospitals'),
            icon: Icon(Icons.local_hospital),
            heroTag: null,
            backgroundColor: Color(0xFFF28976),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              LatLng location = await getUserLocation();
              searchNearby(location.latitude, location.longitude, 'police');
            },
            label: Text('Police Stations'),
            icon: Icon(police),
            heroTag: null,
            backgroundColor: Color(0xFFF9886C),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget toReturn = Scaffold(
      body: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 14.0,
                ),
                myLocationEnabled: true,
                markers: Set<Marker>.of(markers)),
          ],
        ),
        floatingActionButton: sampleWidgetList(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 2.0),
        child: FloatingActionButton(
          onPressed: () => {},
          child: Icon(Icons.arrow_back),
          backgroundColor: Color(0xFFF7B42C),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
    centreCamera();
    return toReturn;
  }

  void searchNearby(double latitude, double longitude, String keyword) async {
    setState(() {
      markers.clear();
    });
    String url =
        '$baseUrl?location=$latitude,$longitude&rankby=distance&type=$keyword&opennow=true&key=$_API_KEY';
    // '$baseUrl?key=$_API_KEY&location=$latitude,$longitude&radius=10000&keyword=$keyword';
    print(url);
    http.Response response = await http.get(url);

    // if (response.statusCode == 200) {
    //   dynamic data = json.decode(response.body);
    //   _handleResponse(data);
    //   if (data['next_page_token'] != null) {
    //     String url = '$baseUrl?pagetoken=${data['next_page_token']}&$_API_KEY';
    //     http.Response response = await http.get(url);
    //     if (response.statusCode == 200) {
    //       dynamic data = json.decode(response.body);
    //       _handleResponse(data);
    //       if (data['next_page_token'] != null) {
    //         String url =
    //             '$baseUrl?pagetoken=${data['next_page_token']}&$_API_KEY';
    //         final response = await http.get(url);
    //         if (response.statusCode == 200) {
    //           dynamic data = json.decode(response.body);
    //           _handleResponse(data);
    //         } else {
    //           throw Exception('An error occurred getting places nearby');
    //         }
    //       }
    //     } else {
    //       throw Exception('An error occurred getting places nearby');
    //     }
    //   }
    // } else {
    //   throw Exception('An error occurred getting places nearby');
    // }

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      _handleResponse(data);
      while (data['next_page_token'] != null) {
        // this loop will run atmost two times
        url = '$baseUrl?pagetoken=${data['next_page_token']}&$_API_KEY';
        response = await http.get(url);
        if (response.statusCode == 200) {
          data = json.decode(response.body);
          _handleResponse(data);
        } else {
          throw Exception('An error occurred getting places nearby');
        }
      }
    }
  }

  void _handleResponse(data) {
    // bad api key or otherwise
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        error = Error.fromJson(data);
      });
      // success
    } else if (data['status'] == "OK") {
      setState(() {
        places = PlaceResponse.parseResults(data['results']);
        for (int i = 0; i < places.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId(places[i].placeId),
              position: LatLng(places[i].geometry.location.lat,
                  places[i].geometry.location.long),
              infoWindow: InfoWindow(
                  title: places[i].name, snippet: places[i].vicinity),
              onTap: () {},
            ),
          );
        }
      });
    } else {
      print(data);
    }
  }
}
