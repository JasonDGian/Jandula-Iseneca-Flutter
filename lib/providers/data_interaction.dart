// Importamos el paquete dio.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iseneca/models/incidencia_dto.dart';

import '../shared/data/data_constants.dart';


class DataInteraction {
  final Dio dio = Dio(BaseOptions(
      baseUrl: DataConstants.urlAPI,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(milliseconds: 3000)));

  Future<List<dynamic>> listaIncidencias() async {
    try {
      final response = await dio.post("/incidencias", data: {});

      // Si la API responde 200
      if (response.statusCode == 201) {
        debugPrint(response.toString());
        return response.data;
      }
      if (response.statusCode == 200) {
        debugPrint(response.toString());
        return response.data;
      }
      debugPrint("Code returned not 200 nor 201");
      return [];
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  // Metodo explicito para crear nuevas incidencias.
  // Recibe numero de aula descripcion y correeo docente porque el resto ded elementos están implementados en el backedn.
  Future<void> crearIncidencia(
      String numeroAula, String descripcion, String correoDocente) async {
    try {
      final Map<String, dynamic> header = {
        "correo-docente": correoDocente.toString()
      };

      final response = await dio.put("/incidencias",
          data: {
            "numeroAula": numeroAula,
            "correoDocente": correoDocente,
            "descripcionIncidencia": descripcion
            //"fechaIncidencia": fechaIncidencia
          },
          options: Options(headers: header));

      // Si la API responde 200
      if (response.statusCode == 201) {
        debugPrint("Creada con exito");
      }
      if (response.statusCode == 200) {
        debugPrint("Modificada con exito");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> modificarIncidencia(IncidenciaDto incidencia) async {
    try {
      final Map<String, dynamic> header = {
        "correo-docente": incidencia.correoDocente.toString()
      };
      final response = await dio.put("/incidencias",
          data: {
            "numeroAula": incidencia.numeroAula,
            "correoDocente": incidencia.correoDocente,
            "fechaIncidencia":
                incidencia.fechaIncidencia.millisecondsSinceEpoch,
            "descripcionIncidencia": incidencia.descripcionIncidencia,
            "estadoIncidencia": incidencia.estadoIncidencia,
            "comentario": incidencia.comentario
          },
          options: Options(headers: header));

      if (response.statusCode == 201) {
        debugPrint("Codigo 201");
      }
      if (response.statusCode == 200) {
        debugPrint("Codigo 200");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
