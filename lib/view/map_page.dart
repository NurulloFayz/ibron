import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPage extends StatefulWidget {
  const MapPage(this.point,{super.key});
  final Point? point;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late List<MapObject> mapObjects = [];

  PlacemarkMapObject getPlaceMark() {
    final point0 = Point(
      latitude: widget.point!.latitude,
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          YandexMap(
            mapObjects: mapObjects,
            onMapCreated: (YandexMapController controller) async {
              // await determinePosition(controller);
              controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: widget.point!,
                    // zoom: 12,
                  ),
                ),
                animation: const MapAnimation(
                  type: MapAnimationType.linear,
                  duration: 1,
                ),
              );

            },
            // rotateGesturesEnabled: false,
            // tiltGesturesEnabled: false,
            mode2DEnabled: true,
            fastTapEnabled: true,
          ),
        ],
      ),
    );
  }
}
