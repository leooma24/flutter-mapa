part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {  

  @override
  Widget build(BuildContext context) {
    final mapaBloc = context.watch<MapaBloc>();    

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon( mapaBloc.state.seguirUbicacion ? Icons.accessibility_new : Icons.directions_run, color: Colors.black87 ),
          onPressed: () {            
            mapaBloc.add( OnSeguirUbicacion() );
          },
        ),
      ),
    );
  }
}