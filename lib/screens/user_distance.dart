import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../extras/extras.dart';

class UserDistance extends StatefulWidget {
  @override
  _UserDistanceState createState() => _UserDistanceState();
}

class _UserDistanceState extends State<UserDistance> {
  bool _showLoading = false;
  GoogleMapController _googleMapController;
  LatLng _currentLocation = LatLng(0.0, 0.0);
  final LatLng _userLocation = const LatLng(21.1449508, 72.7582061);
  Location location = new Location();
  bool _myLocation = false;
  PolylinePoints _polylinePoints;
  List<LatLng> _polylineCoordinates = [];
  Map<PolylineId, Polyline> _polylines = {};

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

  _getPolylines() async {
    setState(() {
      _showLoading = true;
    });
    _polylinePoints = PolylinePoints();
    // PolylineResult polylineResult =
    //     await _polylinePoints.getRouteBetweenCoordinates(
    //         "AIzaSyCqUdk8whvWIsHVAIj_O-WiUltPiCGcfqs",
    //         PointLatLng(_currentLocation.latitude, _currentLocation.longitude),
    //         PointLatLng(_userLocation.latitude, _userLocation.longitude));
    List<PointLatLng> polylineResult =
        _polylinePoints.decodePolyline("_p~iF~ps|U_ulLnnqC_mqNvxq`@");

    if (polylineResult.isNotEmpty) {
      polylineResult.forEach((point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No polyline found."),
        action: SnackBarAction(
          onPressed: _getPolylines,
          label: "Retry",
          textColor: secondaryColor,
        ),
      ));
      setState(() {
        _showLoading = false;
      });
      return;
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: secondaryColor,
      points: _polylineCoordinates,
      width: 3,
    );

    setState(() {
      _polylines.clear();
      LatLng firstLatLng =
          LatLng(polylineResult.first.latitude, polylineResult.first.longitude);
      var s = firstLatLng.latitude,
          n = firstLatLng.latitude,
          w = firstLatLng.longitude,
          e = firstLatLng.longitude;
      for (int i = 1; i < polylineResult.length; i++) {
        var latlng = polylineResult[i];
        s = min(s, latlng.latitude);
        n = max(n, latlng.latitude);
        w = min(w, latlng.longitude);
        e = max(e, latlng.longitude);
      }
      _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(northeast: LatLng(n, e), southwest: LatLng(s, w)),
          50.0));
      _showLoading = false;
      _polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("User Distance"),
        backgroundColor: secondaryColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: _myLocation,
            onMapCreated: _onMapCreated,
            mapType: MapType.satellite,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition:
                CameraPosition(target: _userLocation, zoom: 11),
            markers: getMarkers().values.toSet(),
            polylines: Set<Polyline>.of(_polylines.values),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          mini: true,
                          child: Icon(Icons.add),
                          onPressed: () {
                            _googleMapController
                                .animateCamera(CameraUpdate.zoomIn());
                          },
                          backgroundColor: secondaryColor.withOpacity(0.5),
                        ),
                        FloatingActionButton(
                          mini: true,
                          child: Icon(Icons.remove),
                          onPressed: () {
                            _googleMapController
                                .animateCamera(CameraUpdate.zoomOut());
                          },
                          backgroundColor: secondaryColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: secondaryColor,
                        onPressed: _getPolylines,
                        child: Icon(Icons.directions, color: Colors.white),
                      ),
                      6.addHSpace(),
                      FloatingActionButton(
                        backgroundColor: secondaryColor,
                        onPressed: () {
                          _googleMapController.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                  _currentLocation, 18.0));
                        },
                        child: Icon(Icons.my_location, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Visibility(child: loaderWidget(context), visible: _showLoading),
        ],
      ),
    );
  }
}