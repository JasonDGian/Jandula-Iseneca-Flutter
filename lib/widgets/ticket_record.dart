import 'package:flutter/material.dart';
import 'package:iseneca/models/incidencia_dto.dart';
import 'package:iseneca/shared/data/data_constants.dart';
/// Registro que se renderiza a partir de una incidencia pasada como parametro.
/// El registro cambia de color segun el estado de la incidencia.
/// 
/// 
/// 

class TicketRecord extends StatelessWidget {
  const TicketRecord(
      {super.key, required this.incidencia, required this.funcionActualizar});

  final IncidenciaDto incidencia;

  final Function funcionActualizar;

  @override
  Widget build(BuildContext context) {
    // Botones de poner en hecho y cancelar.
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: decoracionBasadaEnEstado(incidencia),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [   
            botonesAccion( incidencia, funcionActualizar ),       
            _columnaCampo("Estado", Text(incidencia.estadoIncidencia),1),
            _columnaCampo("Usuario", Text(incidencia.correoDocente),1),
            _columnaCampo("Aula", Text(incidencia.numeroAula),1),
            _columnaCampo("Descripción", Text(incidencia.descripcionIncidencia),4),
            _columnaCampo("Fecha", Text(incidencia.fechaIncidencia.toString()),1),
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                child: _columnaCampo("Comentario", Text(incidencia.comentario),4)),
          ],
        ),
      ),
    );
  }



/// Devuelve un Widget que representa un campo en el registro de incidencias.
Widget _columnaCampo(String titulo, dynamic valor, int flex) {
  return Flexible(
    flex: flex,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          color: Colors.white,
          child: Center(
            child: Text(
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          //color: Colors.amber,
          //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: valor,
        ),
      ],
    ),
  );
}

}
class TicketRecordVertical extends StatelessWidget {
  const TicketRecordVertical({super.key, required this.incidencia, required this.funcionActualizar});

  final IncidenciaDto incidencia;

  final Function funcionActualizar;


  _registroCampo( String titulo, String valor )
  {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          //color: Colors.white,
          child: Center(
            child: Text(
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Flexible(
          //color: Colors.amber,
          //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          //padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Text(
            valor),
        ),
      ],
    );
  }  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: decoracionBasadaEnEstado(incidencia),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [      
            _registroCampo("Estado: ", incidencia.estadoIncidencia),
            _registroCampo("Usuario: ", incidencia.correoDocente),
            _registroCampo("Aula: ", incidencia.numeroAula),
            Container(
              color: const Color.fromARGB(80, 255, 255, 255),
              child: ( _registroCampo("Descripción: ", incidencia.descripcionIncidencia))),
            _registroCampo("Fecha: ", incidencia.fechaIncidencia.toString()),
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                child: _registroCampo("Comentario", incidencia.comentario)),
           // botonesAccion( incidencia, funcionActualizar ),    
          ],
        ),
      ),
    );
  }
}

  /// Función que define el color del registro basándose en el estado de la incidencia.
  BoxDecoration decoracionBasadaEnEstado( IncidenciaDto incidencia) {
    var colorRegistro = const Color.fromARGB(255, 200, 252, 204);

    switch (incidencia.estadoIncidencia) {
      case DataConstants.estadoEnProgreso:
        colorRegistro = const Color.fromARGB(255, 254, 255, 174);
        break;
      case DataConstants.estadoCancelada:
        colorRegistro = const Color.fromARGB(255, 156, 156, 156);
        break;
      case DataConstants.estadoPendiente:
        colorRegistro = const Color.fromRGBO(253, 215, 185, 1);
        break;
      case DataConstants.estadoResuelta:
        colorRegistro = const Color.fromARGB(255, 200, 252, 204);
        break;
    }

    return BoxDecoration(
        border: Border.all(color: Colors.black),
        color: colorRegistro,
        borderRadius: const BorderRadius.all(Radius.circular(15)));
  }



 botonesAccion ( IncidenciaDto incidencia, Function funcionActualizar ) 
 { return  Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 216, 215, 228),
          //borderRadius: BorderRadius.only( topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
          border: Border( right: BorderSide(color: Colors.black, width: 1)),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // BOTON DE CANCELAR
          
            //decoration: BoxDecoration( borderRadius: BorderRadius.all( Radius.circular(15)) ),
          Column(
              children: [
                IconButton(
                  onPressed: () {
                    incidencia.estadoIncidencia = DataConstants.estadoCancelada;
                    funcionActualizar(incidencia);
                  },
                  icon: const Icon(Icons.cancel_presentation_rounded),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    incidencia.estadoIncidencia = DataConstants.estadoPendiente;
                    funcionActualizar(incidencia);
                  },
                  icon: const Icon(Icons.preview_outlined),
                  color: const Color.fromARGB(255, 189, 97, 97),
                ),
              ],
            ),
          
          // BOTON DE PENDIENTE

          // BOTON DE EN PROGRESO
          Column(
            children: [
              IconButton(
                onPressed: () {
                  incidencia.estadoIncidencia = DataConstants.estadoEnProgreso;
                  funcionActualizar(incidencia);
                },
                icon: const Icon(Icons.priority_high_outlined),
                color: const Color.fromARGB(255, 212, 157, 6),
              ),
              IconButton(
                onPressed: () {
                  incidencia.estadoIncidencia = DataConstants.estadoResuelta;
                  funcionActualizar(incidencia);
                },
                icon: const Icon(Icons.done),
                color: Colors.green,
              ),
            ],
          ),
          // BOTON DE RESUELTA
        ],
      ),
    );
 }