import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapas_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapas_app/bloc/widgets/widgets.dart';

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
    return Scaffold(
      body: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
        builder: ( _ , state) {             
          return crearMapa(state);
        }
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnUbicacion()
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state ) {
    if( !state.existeUbicacion ) return Center(child: Text('Ubicando...'));
    
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final cameraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 15
    );

    return GoogleMap(
      initialCameraPosition: cameraPosition,
      compassEnabled: true,
      zoomControlsEnabled: false,
      onMapCreated: mapaBloc.initMapa,
    );
  }
}