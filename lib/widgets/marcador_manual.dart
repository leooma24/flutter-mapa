part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    return Stack(
      children: [
        Positioned(
          top: 70,
          left: 20,
          child: FadeInLeft(
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon( Icons.arrow_back, color: Colors.black87 ),
                onPressed: () {
                  busquedaBloc.add( OnCancelarSeleccionManual() );
                },
              )
            ),
          )
        ),

        Center(
          child: Transform.translate(
            offset: Offset(0, -12),
            child: BounceInDown(
              child: Icon( Icons.location_on, size: 50)
            )
          )
        ),

        Positioned(
          bottom: 70,
          left: 40,
          child: FadeInUp (
            child: MaterialButton(
              minWidth: width - 120,
              child: Text('Confirmar Destino', style: TextStyle( color: Colors.white ),),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {                
                this.calcularDestino(context);
              }
            ),
          )
        )

      ],
    );
  }

  void calcularDestino ( BuildContext context ) async {
    final trafficService = TrafficService();
    final mapaBloc = context.read<MapaBloc>();

    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    calculandoAlert(context);
    final trafficResponse = await trafficService.getCoordsInicioyFin(inicio, destino);

    // decodificar polylines
    final geometry = trafficResponse.routes[0].geometry;
    final duracion = trafficResponse.routes[0].duration;
    final distancia = trafficResponse.routes[0].distance;
    final points = Poly.Polyline.Decode( encodedString: geometry, precision: 6).decodedCoords;

    final List<LatLng> rutaCoords = points.map(
      (point) => LatLng(point[0], point[1])
    ).toList();

    mapaBloc.add( OnCrearRutaInicioDestino(rutaCoords, distancia, duracion ));

    Navigator.of(context).pop();

    context.read<BusquedaBloc>().add( OnCancelarSeleccionManual() );


  }
}