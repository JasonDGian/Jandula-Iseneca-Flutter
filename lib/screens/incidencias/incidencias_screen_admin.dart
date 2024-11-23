import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iseneca/models/incidencia_dto.dart';
import 'package:iseneca/providers/data_provider.dart';
import 'package:iseneca/screens/incidencias/incidencias_screen_user.dart';
import 'package:iseneca/widgets/formulario_descripcion.dart';
import 'package:iseneca/widgets/selector_estado_incidencia.dart';
import 'package:iseneca/widgets/selector_fecha.dart';
import 'package:iseneca/widgets/selector_numero_aula.dart';
import 'package:iseneca/widgets/ticket_record.dart';
import 'package:provider/provider.dart';

class IncidenciasScreenAdmin extends StatelessWidget {
  const IncidenciasScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController tcDescripcion = TextEditingController();
    TextEditingController tcNumeroAula = TextEditingController();
    TextEditingController tcFechaInicio = TextEditingController();
    TextEditingController tcFechaFin = TextEditingController();
    TextEditingController tcEstado = TextEditingController();
    TextEditingController tcUsuario = TextEditingController();

    // Formularios .
    var selectorFechaInicio = SelectorFecha(controller: tcFechaInicio);
    var selectorFechaFin = SelectorFecha(controller: tcFechaFin);
    var selectorAula = SelectorNumeroAula(controller: tcNumeroAula);
    var selectorEstado = SelectorEstadoIncidencia(controller: tcEstado);
    var formularioDescripcion = TextFormField(
        controller: tcDescripcion,
        decoration: InputDecoration(label: Text("Descripcion.")));
    var formularioUsuario = TextFormField(
      controller: tcUsuario,
      decoration: InputDecoration(label: Text("Correo docente")),
    );

    // Cerrar sesión.
    void funcionRetroceder() {
      Navigator.pushNamed(context, "/");
    }

    var size = MediaQuery.of(context).size;

    final proveedor = context.watch<DataProvider>();

    final listado = proveedor.incidencias;

    String usuarioAppbar =
        FirebaseAuth.instance.currentUser?.displayName.toString() ?? "nulo";
    String correoProvider =
        FirebaseAuth.instance.currentUser?.email.toString() ?? "nulo";

    proveedor.recuperaUsuario(usuarioAppbar, correoProvider);

    // Control de si el usuario es admin o no.
    var userIsAdmin = proveedor.checkIfAdmin(correoProvider);

    // Bloque que calcula el ancho de los contenedores.
    var anchoContenedorIncidencias = size.width * 0.9;
    bool estrecho = (size.width * 0.3 < 280);
    if (size.width * 0.3 < 280) {
      anchoContenedorIncidencias = size.width;
    }

    // Decoracion de contenedor.
    var boxDecoration = BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15));

    funcionActualizar(IncidenciaDto incidencia) {
      proveedor.modificarIncidencia(incidencia);
    }

    final textButton = TextButton.icon(
      onPressed: () {
        var numAula = tcNumeroAula.text.toString();
        var usuario = tcUsuario.text.toString();
        var estado = tcEstado.text.toString();
        var descripcion = tcDescripcion.text.toString();
        var fechaInicio = tcFechaInicio.text.toString();
        var fechaFin = tcFechaFin.text.toString();
        print("numaula" + numAula);
        print("usuario" + usuario);
        print("estado " + estado);
        print("desc" + descripcion);
        print("inicio" + fechaInicio);
        print("fin" + fechaFin);

        proveedor.buscaIncidenciasFiltro(
            estado, usuario, numAula, descripcion, fechaInicio, fechaFin);
      },
      label: const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Text(
          "Buscar",
          style: TextStyle(color: Colors.white),
        ),
      ),
      icon: const Icon(Icons.search),
      style: const ButtonStyle(
          iconColor: WidgetStatePropertyAll(Colors.white),
          backgroundColor: WidgetStatePropertyAll(
            Color.fromARGB(255, 11, 88, 133),
          )),
    );

    // Contenedor derecho que contiene el listado de incidencias.
    var contenedorIncidencias = Container(
      decoration: boxDecoration,
      padding: const EdgeInsets.all(10),
      height: size.height * 0.88,
      width: anchoContenedorIncidencias,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              selectorEstado,
              SizedBox(width: size.width * 0.15, child: formularioUsuario),
              selectorAula,
              SizedBox(width: size.width * 0.15, child: formularioDescripcion),
              textButton,
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Boton de buscar incidencias.
            const Text("Incidencias",
                style: TextStyle(
                    fontSize: 30, color: Color.fromARGB(255, 20, 94, 155))),
            // Boton de actualizar incidencias o recargar.
            TextButton.icon(
                onPressed: () {
                  proveedor.buscaIncidencias();
                },
                label: const Text(
                  "Actualizar.",
                ),
                icon: const Icon(Icons.refresh)),
          ]),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listado.length,
              itemBuilder: (context, index) {
                if (estrecho) {
                  return TicketRecordVertical(
                      incidencia: listado[index],
                      funcionActualizar: funcionActualizar);
                } else {
                  return TicketRecord(
                      incidencia: listado[index],
                      funcionActualizar: funcionActualizar);
                }
              },
            ),
          ),
        ],
      ),
    );

    // Si el usuario es administrador lo indica en el appbar.
    var usuarioChecked = userIsAdmin ? "$usuarioAppbar (admin)" : usuarioAppbar;

    // Barra de navegación de la pagina.
    var appBar = AppBar(
      elevation: 5.0,
      backgroundColor: Colors.white,
      title: const Text("Incidencias"),
      actions: [
        // Si el usuario es administrador devuelve la opcion de pasar a vista de usuario.
        verVistaUsuario(context, userIsAdmin),
        Text(usuarioChecked),
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: IconButton(
              onPressed: funcionRetroceder, icon: const Icon(Icons.output)),
        ) // personalizar este boton
      ],
    );

    // Cuerpo de la pagina mostrada a los administradores...
    var body = Container(
      color: const Color.fromARGB(255, 207, 218, 230),
      child: Center(
        child: SingleChildScrollView(child: contenedorIncidencias),
      ),
    );

    // Retorno de la vista.
    return userIsAdmin
        ? SafeArea(child: Scaffold(appBar: appBar, body: body))
        : const IncidenciasScreenUser();
  }

  // Funcion que recibe el contexto de ejecucion y un valor booleano.
  // el valor booleano sirve para diferenciar si el usuario es admin o no.
  // Si el usuario es admin muestra la opcion de pasar a vista de usuario.
  verVistaUsuario(BuildContext context, bool userIsAdmin) {
    return userIsAdmin
        ? TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "incidencias_screen_user");
            },
            child: const Text("Ver vista usuario"),
          )
        : const Text("");
  }
}
