part of 'busqueda_bloc.dart';

@immutable
abstract class BusquedaEvent {}

class OnSeleccionManual extends BusquedaEvent {}

class OnConfirmarDestino extends BusquedaEvent {}

class OnCancelarSeleccionManual extends BusquedaEvent {}

class OnAgregarHistorial extends BusquedaEvent {

  final SearchResult result;
  OnAgregarHistorial(this.result);

}
