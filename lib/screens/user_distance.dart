import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../extras/extras.dart';

class UserDistance extends StatefulWidget {
  @override
  _UserDistanceState createState() => _UserDistanceState();
}

class _UserDistanceState extends State<UserDistance> {
  GoogleMapController _googleMapController;
  LatLng _currentLocation = LatLng(0.0, 0.0);
  final LatLng _userLocation = const LatLng(21.1449508, 72.7582061);
  Location location = new Location();
  bool _myLocation = false;

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  Map<String, Marker> getMarkers() {
    final marker = Marker(
        markerId: MarkerId("0"),
        position: _userLocation,
        infoWindow: InfoWindow(title: "Any User", snippet: "User's Address"));
    return {"UserName": marker};
  }

  @override
  void initState() {
    _getUserLocation().then((value) {
      _currentLocation = LatLng(value.latitude, value.longitude);
      setState(() {
        _myLocation = true;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _myLocation = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("User Distance"),
        backgroundColor: secondaryColor,
      ),
      body: GoogleMap(
        myLocationEnabled: _myLocation,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _userLocation, zoom: 11),
        markers: getMarkers().values.toSet(),
      ),
    );
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = false;
    LocationPermission locationPermission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled)
        return Future.error("Location services are disabled.");
    }
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }
}
