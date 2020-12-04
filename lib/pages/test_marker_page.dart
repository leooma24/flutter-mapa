import 'package:flutter/material.dart';
import 'package:mapas_app/custom_markers/markers.dart';

class TestMarkerPage extends StatelessWidget {  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          child: CustomPaint(
            painter: MarkerDestinoPainter('Nu casa estara cerca de la tuya mientras tu lo desees por esta razón lo seguire intentando.', 30250),
          ),
        ),
      ),
    );
  }
}