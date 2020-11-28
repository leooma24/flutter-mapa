import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import 'package:mapas_app/helpers/debouncer.dart';
import 'package:mapas_app/models/geo_result.dart';
import 'package:mapas_app/models/traffic_response.dart';

class TrafficService {

  TrafficService._privateContructor();
  static TrafficService _instance = TrafficService._privateContructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>( duration: Duration( milliseconds: 400 ));

  final StreamController<GeoResponse> _sugerenciasStreamController = new StreamController<GeoResponse>.broadcast();
  Stream<GeoResponse> get sugerenciasStream => this._sugerenciasStreamController.stream;

  final _baseUrl = 'https://api.mapbox.com/';
  final _baseUrlDir = 'directions/v5/mapbox/driving/';
  final _baseUrlGeo = 'geocoding/v5/mapbox.places/';
  final _apiKey = 'pk.eyJ1IjoibGVvb21hMjQiLCJhIjoiY2tod3ljcmRjMHgyZjJ6bnR2bnI1dTMxayJ9.R4-UAvav1toPxyFhNqu0oQ';

  Future<DrivingResponse> getCoordsInicioyFin( LatLng inicio, LatLng destino ) async {  
    try {
      final coordsString = '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
      final url = '${ this._baseUrl }${ this._baseUrlDir }$coordsString';        
      final resp = await this._dio.get( url, queryParameters: {
        'alternatives': 'true',
        'geometries': 'polyline6',
        'steps': 'false',
        'access_token': this._apiKey,
        'language': 'es'
      });
      final data = DrivingResponse.fromJson(resp.data);

      return data;
    } catch (e) {
      return DrivingResponse();
    }
    
  }

  Future<GeoResponse> getResultadosPorQuery( String busqueda, LatLng proximidad ) async {    
    try {
      final coordsString = '${proximidad.longitude},${proximidad.latitude}';
      final url = '${ this._baseUrl }${ this._baseUrlGeo }$busqueda.json';
      final resp = await this._dio.get( url, queryParameters: {
        'access_token': this._apiKey,            
        'autocomplete': 'true',
        'proximity': coordsString,
        'language': 'es'
      });    
      final data = geoResponseFromJson(resp.data);
      return data;
    } catch (e) {
      return GeoResponse( features: []);
    }    
  }

  void getSugerenciasPorQuery( String busqueda, LatLng proximidad ) {
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final resultados = await this.getResultadosPorQuery(busqueda, proximidad);
      this._sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration( milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed( Duration( milliseconds: 201)).then( (_) => timer.cancel());
  }
}