import 'package:flutter/material.dart';
import 'package:iseneca/providers/data_provider.dart';
import 'package:provider/provider.dart';


class SelectorNumeroAula extends StatefulWidget {
  const SelectorNumeroAula({super.key, required this.funcion});

  // Especificamos el tipo de la función
  final Function(String) funcion;

  @override
  _SelectorNumeroAulaState createState() => _SelectorNumeroAulaState();
}

class _SelectorNumeroAulaState extends State<SelectorNumeroAula> {
  String aulaSeleccionada = "default";

  @override
  Widget build(BuildContext context) {
    final proveedor = context.watch<DataProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Numero de aula: "),
        const SizedBox(
          width: 5,
        ),
        DropdownButton<String>(
          icon: const Icon(Icons.arrow_drop_down_circle),
          value: aulaSeleccionada,
          items: proveedor.entradasNumAula,
          // Funcion que se triggerea al cambiar
          onChanged: (nuevoValor) {
            setState(() {
              aulaSeleccionada = nuevoValor!;
            });
            // llamada a la funcion pasada por parametro.
            widget.funcion(nuevoValor!);
          },
        )
      ],
    );
  }
}
