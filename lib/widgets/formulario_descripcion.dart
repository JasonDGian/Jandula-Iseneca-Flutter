import 'package:flutter/material.dart';

class FormularioDescripcion extends StatelessWidget {
  // Controlador para el texto.
  final dynamic paramController;

  const FormularioDescripcion({super.key, required this.paramController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: paramController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: "Descripcion de la incidencia",
                fillColor: Color.fromARGB(255, 247, 255, 254),
                filled: true),
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 5,
          ),
        ),
      ),
    );
  }
}
