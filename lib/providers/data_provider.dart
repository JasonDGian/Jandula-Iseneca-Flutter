import 'package:flutter/material.dart';
import 'package:iseneca/models/incidencia_dto.dart';
import 'package:iseneca/providers/data_interaction.dart';
import 'package:iseneca/shared/data/data_constants.dart';

class DataProvider extends ChangeNotifier {
  // En futuro sostituir por una llamada a microservicio que devuelve el listado de aulas disponibles.
  List<DropdownMenuItem<String>> entradasNumAula = const [
    DropdownMenuItem<String>(
        value: "default",
        child: Text(
          "Selección.",
          style: TextStyle(color: Color.fromARGB(255, 151, 10, 0)),
        )),
    DropdownMenuItem<String>(value: "0.1", child: Text("0.1")),
    DropdownMenuItem<String>(value: "0.2", child: Text("0.2")),
    DropdownMenuItem<String>(value: "0.3", child: Text("0.3")),
    DropdownMenuItem<String>(value: "0.4", child: Text("0.4")),
    DropdownMenuItem<String>(value: "0.5", child: Text("0.5")),
  ];

// Listado de botones seleccionables basado en constantes para filtro de busqueda.
  List<DropdownMenuItem<String>> estadosIncidencia = const [
    DropdownMenuItem<String>(
        value: "default",
        child: Text(
          "Selección.",
          style: TextStyle(color: Color.fromARGB(255, 151, 10, 0)),
        )),
    DropdownMenuItem<String>(
        value: DataConstants.estadoCancelada,
        child: Text(DataConstants.estadoCancelada)),
    DropdownMenuItem<String>(
        value: DataConstants.estadoPendiente,
        child: Text(DataConstants.estadoPendiente)),
    DropdownMenuItem<String>(
        value: DataConstants.estadoEnProgreso,
        child: Text(DataConstants.estadoEnProgreso)),
    DropdownMenuItem<String>(
        value: DataConstants.estadoResuelta,
        child: Text(DataConstants.estadoResuelta)),
  ];

  // Instancia dio.
  DataInteraction dataInteraction = DataInteraction();

  // Lista de usuarios administradores.
  List<String> administradores = [
    "davjasg@gmail.com"
  ]; // añadir usuarios que deseamos incluir como administradores.

  // Almacen de incidencias en Provider.
  List<IncidenciaDto> incidencias = [];

  // Metodo del provider que recupera incidenecias y las almacena en el provider.
  Future<void> buscaIncidencias() async {
    incidencias.clear();
    final respuesta = await dataInteraction.listaIncidencias();

    for (var x in respuesta) {
      // introduce la primera recuperada (la ultima añadida) a la lista como primer elemento.
      incidencias.insert(0, IncidenciaDto.fromJson(x));
    }
    notifyListeners();
  }

  // Helper para añadir filtro no nulo.
  void addFilter(Map<String, String> dataFilter, String key, String? value) {
    if (value != null && value != "default" && value.isNotEmpty) {
      dataFilter[key] = value;
    }
  }

  // Metodo del provider que recupera incidenecias y las almacena en el provider basandose en el filtro.
  Future<void> buscaIncidenciasFiltro(
      String? estado,
      String? usuario,
      String? numAula,
      String? descripcion,
      String? fechaInicio,
      String? fechaFin) async {
    // Mapa que funge de json de busqueda.
    Map<String, String> dataFilter = {};

    addFilter(dataFilter, "estadoIncidencia", estado);
    addFilter(dataFilter, "correoDocente", usuario);
    addFilter(dataFilter, "numeroAula", numAula);
    addFilter(dataFilter, "descripcionIncidencia", descripcion);
    addFilter(dataFilter, "fechaInicio", fechaInicio);
    addFilter(dataFilter, "fechaFin", fechaFin);

    print("Filtro actual en PROVIDER:");
    print(dataFilter);

    // Limpia el listado actual.
    incidencias.clear();

    // Envia parametros a dio.
    final respuesta = await dataInteraction.listaIncidenciasFiltro(dataFilter);

    // Renderiza en orden inverso a medida que recibe.
    for (var x in respuesta) {
      incidencias.insert(0, IncidenciaDto.fromJson(x));
    }

    notifyListeners();
  }

  // Generacion incidencias.
  String numero = "";
  String usuario = "";
  String correo = "";
  DateTime? fecha;
  String descripcion = "";
  String estado = "";
  String comentario = "";

  // Funcion de seguridad para 'vaciar valores'.
  _clearValues() {
    numero = "";
    fecha = null;
    descripcion = "";
    estado = "";
    comentario = "";
  }

  Future<void> crearIncidencia() async {
    debugPrint("antes de provider ejecutar");
    await dataInteraction.crearIncidencia(numero, descripcion, correo);
    debugPrint("despues de provider ejecutar");
    buscaIncidencias(); // actualiza la lista.
    notifyListeners(); // notifica a los oyentes.
    _clearValues(); // limpia valores del provider.
  }

  // Metodo que recibe un objeto incidencia DTO y lo envia tal cual para actualizar o crear.
  Future<void> modificarIncidencia(IncidenciaDto incidencia) async {
    await dataInteraction.modificarIncidencia(incidencia);
    buscaIncidencias();
    notifyListeners();
    _clearValues(); // limpia valores del provider.
  }

  void recuperaUsuario(String? user, String? correo) {
    usuario = user ?? "nulo en funcion";
    this.correo = correo ?? "nulo en funcion";
    notifyListeners();
  }

  // Funcion que devuelve true o false dependiendo de si el usuario
  // pertenece al a lista de administradores.
  bool checkIfAdmin(String correo) {
    return administradores.contains(correo);
  }
}
