import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/themes/uber_map_theme.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super( MapaState() );

  GoogleMapController _mapController;
  
  void moverCamara( LatLng destino ) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    _mapController.animateCamera( cameraUpdate );
  }

  void initMapa( GoogleMapController controller ) {
    if( !state.mapaListo ) {
      _mapController = controller;
      _mapController.setMapStyle( jsonEncode(uberMapTheme) );
    }    
    add( OnMapaListo() );
  }

  @override
  Stream<MapaState> mapEventToState( MapaEvent event ) async* {    
    if( event is OnMapaListo ) {
      yield state.copyWith( mapaListo: true );
    }
  }
}
