import 'package:flutter/material.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  BMFMapOptions mapOptions = BMFMapOptions(
    //center: BMFCoordinate(39.917215, 116.380341),
    zoomLevel: 12,
    //mapPadding: BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: BMFMapWidget(
          onBMFMapCreated: (controller) {},
          mapOptions: mapOptions,
        ),
      ),
    );
  }
}
