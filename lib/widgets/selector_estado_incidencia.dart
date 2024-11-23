import 'package:flutter/material.dart';
import 'package:iseneca/providers/data_provider.dart';
import 'package:provider/provider.dart';

class SelectorEstadoIncidencia extends StatefulWidget {
  const SelectorEstadoIncidencia({super.key, required this.controller});

  final TextEditingController controller;

  @override
  _SelectorEstadoIncidenciaState createState() =>
      _SelectorEstadoIncidenciaState();
}

class _SelectorEstadoIncidenciaState extends State<SelectorEstadoIncidencia> {
  String estadoSeleccionado = "default";

  //funcion que resetea el estado del boton.
  void funcionReset() {
    setState(() {
      estadoSeleccionado = "default";
    });
  }

  @override
  Widget build(BuildContext context) {
    final proveedor = context.watch<DataProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Estado: "),
        const SizedBox(
          width: 5,
        ),
        DropdownButton<String>(
          icon: const Icon(Icons.arrow_drop_down_circle),
          value: estadoSeleccionado,
          items: proveedor.estadosIncidencia,
          // Funcion que se triggerea al cambiar
          onChanged: (nuevoValor) {
            setState(() {
              estadoSeleccionado = nuevoValor!;
              widget.controller.text = nuevoValor;
            });
          },
        )
      ],
    );
  }
}
