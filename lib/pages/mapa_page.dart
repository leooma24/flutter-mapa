import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:mapas_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapas_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';

import 'package:mapas_app/widgets/widgets.dart';

class MapaPage extends StatefulWidget {  

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final busquedaBloc = context.watch<BusquedaBloc>();
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: ( _ , state) {             
              return crearMapa(state);
            }
          ),
          // Hacer el toggle cuando estoy manualmente
          busquedaBloc.state.seleccionManual 
          ? MarcadorManual()
          : Positioned(
            top: 15,            
            child: SearchBar()
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnUbicacion(),
          BtnSeguirUbicacion(),
          BtnMiRuta()
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state ) {
    if( !state.existeUbicacion ) return Center(child: Text('Ubicando...'));
    
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add( OnNuevaUbicacion( state.ubicacion ) );

    final cameraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 15
    );

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (BuildContext context, state) { 
        return GoogleMap(
          initialCameraPosition: cameraPosition,
          compassEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: mapaBloc.initMapa,
          polylines: mapaBloc.state.polylines.values.toSet(),
          markers: mapaBloc.state.markers.values.toSet(),
          onCameraMove: ( cameraPosition ) {
            mapaBloc.add( OnMovioMapa( cameraPosition.target ));
          }
        );
      },
    );    
  }
}