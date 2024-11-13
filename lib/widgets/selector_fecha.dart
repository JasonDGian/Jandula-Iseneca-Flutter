import 'package:flutter/material.dart';

class SelectorFecha extends StatelessWidget {
  const SelectorFecha({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    Future<void> seleccionaFecha(context) async {
      DateTime? seleccionada = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime(2124));

      if (seleccionada != null) {
        controller.text = seleccionada
            .toString()
            .split(" ")[0]; //controlar el formato tostring
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: controller,
          decoration: inputDecor,
          readOnly: true,
          onTap: () {
            seleccionaFecha(context);
          },
        ),
      ),
    );
  }
}

const inputDecor = InputDecoration(
  labelText: 'FECHA',
  filled: true,
  prefix: Icon(Icons.calendar_today),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
  ),
);
