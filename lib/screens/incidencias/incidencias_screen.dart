import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iseneca/providers/data_provider.dart';
import 'package:iseneca/screens/incidencias/incidencias_screen_admin.dart';
import 'package:iseneca/screens/incidencias/incidencias_screen_user.dart';
import 'package:provider/provider.dart';

class IncidenciasScreen extends StatelessWidget {
  const IncidenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proveedor = context.watch<DataProvider>();

    String usuarioAppbar =
        FirebaseAuth.instance.currentUser?.displayName.toString() ?? "nulo";
    String correoProvider =
        FirebaseAuth.instance.currentUser?.email.toString() ?? "nulo";
    proveedor.recuperaUsuario(usuarioAppbar, correoProvider);

    // Control de si el usuario es admin o no.
    var userIsAdmin = proveedor.checkIfAdmin(correoProvider);

    // Retorno de la vista.
    return userIsAdmin
        ? const IncidenciasScreenAdmin()
        : const IncidenciasScreenUser();
  }
}
