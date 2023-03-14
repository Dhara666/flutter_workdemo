import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/common_widget/common_textFormFiled.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/geolocation_pages/address_dialog_page.dart';
import 'package:sheet_demo/pages/geolocation_pages/place_service.dart';
import 'package:uuid/uuid.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  PlaceApiProvider apiProvider;

  CameraPosition _initialLocation =
      // CameraPosition(target: LatLng(21.1702, 72.8311));
      CameraPosition(target: LatLng(0.0,0.0));
  GoogleMapController mapController;

  Position _currentPosition;
  String _currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final destinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  final sessionToken = Uuid().v4();

  Position destinationCoordinates;
  Position startCoordinates;

  Set<Marker> markers = {};
  Marker destinationMarker;
  Marker startMarker;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiProvider = PlaceApiProvider(sessionToken);
    _getCurrentLocation();
   // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).googleMapAppbar),
      body: Stack(
        children: [
          GoogleMap(
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            markers: markers != null ? Set<Marker>.from(markers) : null,
           // trafficEnabled: true,
            //zoomGesturesEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    commonMapTextFormFiled(
                        labelText: GoogleMapString.sourceLocation,
                        icon: (Icons.adjust_rounded),
                        iconColor: Colors.blueAccent,
                        controller: startAddressController,
                        focusNode: startAddressFocusNode,
                        function: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          openPlacePicker();
                        },
                        onSaved: (String value) {
                          setState(() {
                            _startAddress = value;
                          });
                        }),
                    SizedBox(height: 10),
                    commonMapTextFormFiled(
                        labelText: GoogleMapString.destination,
                        icon: (Icons.location_on),
                        iconColor:  ColorResource.red,
                        controller: destinationAddressController,
                        focusNode: destinationAddressFocusNode,
                        function: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          openPlacePicker2();
                        },
                        onSaved: (String value) {
                          setState(() {
                            _destinationAddress = value;
                          });
                        }),
                    SizedBox(height: 10),
                    _placeDistance != null
                        ? Text(
                            '${GoogleMapString.distance} : $_placeDistance km',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                    commonHeightBox(heightBox: 5),
                    Container(
                      height: 35,
                      width: 80,
                      decoration: BoxDecoration(
                          color:  ColorResource.themeColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.only(left: 7),
                                  child: Icon(
                                    Icons.navigation_outlined,
                                    color: ColorResource.white,
                                    size: 20,
                                  ))),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: MaterialButton(
                              padding: EdgeInsets.only(right: 10),
                              onPressed: (_startAddress != '' &&
                                      _destinationAddress != '')
                                  ? () async {
                                      startAddressFocusNode.unfocus();
                                      destinationAddressFocusNode.unfocus();
                                      setState(() {
                                        if (markers.isNotEmpty) markers.clear();
                                        if (polylines.isNotEmpty)
                                          polylines.clear();
                                        if (polylineCoordinates.isNotEmpty)
                                          polylineCoordinates.clear();
                                        _placeDistance = null;
                                      });
                                      _calculateDistance();
                                    }
                                  : () {
                                      print("null receive");
                                    },
                              child: Text(
                                GoogleMapString.start,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  openPlacePicker() async {
    final sessionToken = Uuid().v4();

    print("my session Token :- $sessionToken");
    final Suggestion result = await showDialog(
      context: context,
      builder: (BuildContext context) => AddressDialogPage(
        sessionToken: sessionToken,
      ),
    );
    if (result != null) {
      print("Our Result:--$result");
      setState(() {
        startAddressController.text = result.description;
        _startAddress = result.description;
      });
    }
  }

  openPlacePicker2() async {
    final sessionToken = Uuid().v4();

    print("my session Token :- $sessionToken");
    final Suggestion result = await showDialog(
      context: context,
      builder: (BuildContext context) => AddressDialogPage(
        sessionToken: sessionToken,
      ),
    );
    if (result != null) {
      print("Our Result2:--$result");
      setState(() {
        destinationAddressController.text = result.description;
        _destinationAddress = result.description;
      });
    }
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(21.1702, 72.8311),
              zoom: 14.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _calculateDistance() async {
    try {
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
            speed: 0,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speedAccuracy: 0,
                timestamp: null,
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : Position(
            speed: 0,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speedAccuracy: 0,
                timestamp: null,
                latitude: startPlacemark[0].latitude,
                longitude: startPlacemark[0].longitude);
        Position destinationCoordinates = Position(
            speed: 0,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speedAccuracy: 0,
            timestamp: null,
            latitude: destinationPlacemark[0].latitude,
            longitude: destinationPlacemark[0].longitude);

        // Start Location Marker
        startMarker = Marker(
            markerId: MarkerId('$startCoordinates'),
            position: LatLng(
              startCoordinates.latitude,
              startCoordinates.longitude,
            ),
            infoWindow: InfoWindow(
              title: 'Start Point',
              snippet: _startAddress,
            ),
            icon: await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(devicePixelRatio: 2.5, size: Size(5, 5)),
                'assets/images/des.png'));

        // Destination Location Marker
        destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination Point',
            snippet: _destinationAddress,
          ),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 3.5, size: Size(5, 5)),
              'assets/images/des.png'),
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny =
            (startCoordinates.latitude <= destinationCoordinates.latitude)
                ? startCoordinates.latitude
                : destinationCoordinates.latitude;
        double minx =
            (startCoordinates.longitude <= destinationCoordinates.longitude)
                ? startCoordinates.longitude
                : destinationCoordinates.longitude;
        double maxy =
            (startCoordinates.latitude <= destinationCoordinates.latitude)
                ? destinationCoordinates.latitude
                : startCoordinates.latitude;
        double maxx =
            (startCoordinates.longitude <= destinationCoordinates.longitude)
                ? destinationCoordinates.longitude
                : startCoordinates.longitude;

        _southwestCoordinates = Position(
            speed: 0,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speedAccuracy: 0,
            timestamp: null,
            latitude: miny,
            longitude: minx);
        _northeastCoordinates = Position(
            speed: 0,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speedAccuracy: 0,
            timestamp: null,
            latitude: maxy,
            longitude: maxx);

        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );
        await _createPolylines(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;

        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyB_kIX5UrOzY9KC14LVNRAIsZCkx3xBXeA', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );
    print("Result:- ${result.status}");
    print("Result:- ${result.points}");
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color:  ColorResource.themeColor,
      visible: true,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
  }
}
