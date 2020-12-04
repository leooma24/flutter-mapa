part of 'widgets.dart';

class SearchBar extends StatelessWidget {  

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: FadeInDown (
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 30),
          width: width,
          child: GestureDetector(
            onTap: () async {
              final proximidad = context.read<MiUbicacionBloc>().state.ubicacion;
              final historial = context.read<BusquedaBloc>().state.historial;
              final SearchResult resultado = await showSearch(
                context: context, 
                delegate: SearchDestination(proximidad, historial)
              );
              retornoBusqueda( resultado, context );
            },
            child: Container(
              padding: EdgeInsets.symmetric( horizontal: 20, vertical: 13),
              width: double.infinity,           
              child: Text('¿Dónde quires ir?', style: TextStyle( color: Colors.black87 ),),       
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow( color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void retornoBusqueda( SearchResult resultado, BuildContext context ) async {
    final busquedaBloc = context.read<BusquedaBloc>();
    if( resultado.cancelo ) return;

    if( resultado.manual ) {
      busquedaBloc.add( OnSeleccionManual() );  
      return;    
    }
    calculandoAlert(context);
    final trafficService = new TrafficService();
    final mapaBloc = context.read<MapaBloc>();

    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = resultado.position;

    final drivingTraffic = await trafficService.getCoordsInicioyFin(inicio, destino);

    final geometry = drivingTraffic.routes[0].geometry;
    final duracion = drivingTraffic.routes[0].duration;
    final distancia = drivingTraffic.routes[0].distance;

    final points = Poly.Polyline.Decode( encodedString: geometry, precision: 6 );
    final List<LatLng> rutaCoordenadas = points.decodedCoords.map( 
      (point) => LatLng(point[0], point[1]) 
    ).toList();

    mapaBloc.add( OnCrearRutaInicioDestino(rutaCoordenadas, distancia, duracion, resultado.nombreDestino));
    Navigator.of(context).pop();

    busquedaBloc.add( OnAgregarHistorial(resultado) );

  }
}