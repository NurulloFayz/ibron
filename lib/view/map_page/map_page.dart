import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'address_detail.dart';
import 'app_lat_long.dart';
import 'service.dart';
//import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key,required this.point});
  final Point? point;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String addressDetail = 'Your Location';
  final AddressDetail repository = AddressDetail();

  late List<MapObject> mapObjects = [];
  final mapController = Completer<YandexMapController>();

  PlacemarkMapObject getPlaceMark() {
    final point0 = Point(
      latitude: widget.point!.longitude,
      longitude: widget.point!.longitude,
    );
    return PlacemarkMapObject(
      mapId: const MapObjectId('mapIdCurrent'),
      point: widget.point ?? point0,
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          scale: 3,
          image: BitmapDescriptor.fromAssetImage(
              'assets/images/ic_location.png'
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    mapObjects = [getPlaceMark()];
    _initPermission().ignore();
    super.initState();
  }
  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }


  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    updateAddressDetail(location);
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(
      AppLatLong appLatLong,
      ) async {
    (await mapController.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Xarita',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w500)),),
      ),
      body: Stack(
        children: [
          YandexMap(

              onMapCreated: (controller) {
            mapController.complete(controller);
          }, onCameraPositionChanged: (cameraPos, reason, finished) {
            if (finished) {
              updateAddressDetail(AppLatLong(
                  lat: cameraPos.target.latitude,
                  long: cameraPos.target.longitude));
            }
          }
          ),
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Icon(Icons.my_location_rounded),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchCurrentLocation();
        },
        child: Icon(Icons.my_location_rounded),
      ),
    );
  }

  Future<void> updateAddressDetail(AppLatLong latLong) async {
    try {
      addressDetail = "..loading";
      setState(() {});
      Point point = Point(latitude: latLong.lat, longitude: latLong.long);
      final results = YandexSearch.searchByPoint(
        point: point,
        searchOptions: const SearchOptions(),
      );

      final session = await results.result;
      addressDetail =  session.items?.first.name ?? '';
      setState(() {});
    } catch (e) {
      addressDetail = e.toString();
      setState(() {});
      print("error ---------- > $e");
    }
  }
}

