// To parse this JSON data, do
//
//     final incidenciaDto = incidenciaDtoFromJson(jsonString);

import 'dart:convert';

List<IncidenciaDto> incidenciaDtoFromJson(String str) =>
    List<IncidenciaDto>.from(
        json.decode(str).map((x) => IncidenciaDto.fromJson(x)));

String incidenciaDtoToJson(List<IncidenciaDto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Metodo que genera una versión "vacia" del modelo incidencia.
generaVacia() {
  return IncidenciaDto(
      numeroAula: "",
      correoDocente: "",
      fechaIncidencia: DateTime.now(),
      descripcionIncidencia: "",
      estadoIncidencia: "",
      comentario: "");
}

class IncidenciaDto {
  String numeroAula;
  String correoDocente;
  DateTime fechaIncidencia;
  String descripcionIncidencia;
  String estadoIncidencia;
  String comentario;

  IncidenciaDto({
    required this.numeroAula,
    required this.correoDocente,
    required this.fechaIncidencia,
    required this.descripcionIncidencia,
    required this.estadoIncidencia,
    required this.comentario,
  });

  factory IncidenciaDto.fromJson(Map<String, dynamic> json) => IncidenciaDto(
        numeroAula: json["numeroAula"],
        correoDocente: json["correoDocente"],
        fechaIncidencia:
            DateTime.fromMillisecondsSinceEpoch(json["fechaIncidencia"]),
        descripcionIncidencia: json["descripcionIncidencia"],
        estadoIncidencia: json["estadoIncidencia"],
        comentario: json["comentario"],
      );

  Map<String, dynamic> toJson() => {
        "numeroAula": numeroAula,
        "correoDocente": correoDocente,
        "fechaIncidencia":
            DateTime.parse(fechaIncidencia.toString()).microsecondsSinceEpoch,
        "descripcionIncidencia": descripcionIncidencia,
        "estadoIncidencia": estadoIncidencia,
        "comentario": comentario,
      };

  @override
  String toString() {
    return 'IncidenciaDto(numeroAula: $numeroAula, correoDocente: $correoDocente, '
        'fechaIncidencia: $fechaIncidencia, descripcionIncidencia: $descripcionIncidencia, '
        'estadoIncidencia: $estadoIncidencia, comentario: $comentario)';
  }
}
