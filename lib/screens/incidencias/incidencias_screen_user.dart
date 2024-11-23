import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iseneca/models/incidencia_dto.dart';
import 'package:iseneca/providers/data_provider.dart';
import 'package:iseneca/shared/data/data_constants.dart';
import 'package:iseneca/widgets/formulario_descripcion.dart';
import 'package:iseneca/widgets/selector_fecha.dart';
import 'package:iseneca/widgets/selector_numero_aula.dart';
import 'package:iseneca/widgets/ticket_record.dart';
import 'package:provider/provider.dart';

class IncidenciasScreenUser extends StatelessWidget {
  const IncidenciasScreenUser({super.key});

  @override
  Widget build(BuildContext context) {
    //IncidenciaDto incidenciaTemporal;
    //String numeroAula;

    TextEditingController tcDescripcion = TextEditingController();
    TextEditingController tcNumeroAula = TextEditingController();
    TextEditingController tcFecha = TextEditingController();

    void funcionRetroceder() {
      Navigator.pushNamed(context, "/");
    }

    // Widget selector de aula, recibe una función que
    // define el comportamiento del valor seleccionado.
    var selectorAula = SelectorNumeroAula(
      controller: tcNumeroAula,
    );
    var selectorFecha = SelectorFecha(controller: tcFecha);

    // Formulario de descripcion que espera un text controller.
    var formularioDescripcion = FormularioDescripcion(
      paramController: tcDescripcion,
    );

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
    var anchoContenedorFormulario = size.width * 0.25;
    var anchoContenedorIncidencias = size.width * 0.7;
    bool estrecho = (size.width * 0.3 < 280);
    if (size.width * 0.3 < 280) {
      anchoContenedorFormulario = size.width;
      anchoContenedorIncidencias = size.width;
    }

    final textButton = TextButton.icon(
      onPressed: () {
        // LOGICA DE CREACION Y ENVIO.
        proveedor.descripcion = tcDescripcion.text;
        proveedor.numero = tcNumeroAula.text;
        proveedor.fecha = DateTime.now();
        proveedor.comentario = "";
        proveedor.estado = DataConstants.estadoPendiente;
        proveedor.crearIncidencia(); // Carga la incidencia.
      },
      label: const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Text(
          "Señalar incidencia",
          style: TextStyle(color: Colors.white),
        ),
      ),
      icon: const Icon(Icons.announcement),
      style: const ButtonStyle(
          iconColor: WidgetStatePropertyAll(Colors.white),
          backgroundColor: WidgetStatePropertyAll(
            Color.fromARGB(255, 11, 88, 133),
          )),
    );

    const recordatorio = Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            DataConstants.avisoFormularioIncidencias1,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          Text(
            DataConstants.avisoFormularioIncidencias2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    // Decoracion de contenedor.
    var boxDecoration = BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15));

    // Contenedor izquierdode elementos del formulario.
    var contenedorFormulario = Container(
      decoration: boxDecoration,
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: anchoContenedorFormulario,
      child: Column(
        children: [
          const Text(
            DataConstants.tituloFormularioIncidencias,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, color: Color.fromARGB(255, 20, 94, 155)),
          ),
          selectorAula,
          selectorFecha,
          formularioDescripcion,
          recordatorio,
          textButton
        ],
      ),
    );

    funcionActualizar(IncidenciaDto incidencia) {
      proveedor.modificarIncidencia(incidencia);
    }

    // Contenedor derecho que contiene el listado de incidencias.
    var contenedorIncidencias = Container(
      decoration: boxDecoration,
      padding: const EdgeInsets.all(10),
      height: size.height * 0.88,
      width: anchoContenedorIncidencias,
      child: Column(
        children: [
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Boton de buscar incidencias.
                SizedBox(),
                Text("Incidencias",
                    style: TextStyle(
                        fontSize: 30, color: Color.fromARGB(255, 20, 94, 155))),
                // Boton de actualizar incidencias o recargar.
                SizedBox(),
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

    // Cuerpo de la pagina mostrada a los usuarios..
    var body = Container(
      color: const Color.fromARGB(255, 207, 218, 230),
      child: Center(
        child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              contenedorFormulario,
              SizedBox(
                width: size.width * 0.01,
              ),
              contenedorIncidencias
            ],
          ),
        ),
      ),
    );

    // Retorno de la vista.
    return SafeArea(child: Scaffold(appBar: appBar, body: body));
  }

  // Funcion que recibe el contexto de ejecucion y un valor booleano.
  // el valor booleano sirve para diferenciar si el usuario es admin o no.
  // Si el usuario es admin muestra la opcion de pasar a vista de usuario.
  verVistaUsuario(BuildContext context, bool userIsAdmin) {
    return userIsAdmin
        ? TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "incidencias_screen_admin");
            },
            child: const Text("Ver vista admin"),
          )
        : const Text("");
  }
}
