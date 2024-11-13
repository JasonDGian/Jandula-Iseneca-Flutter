class DataConstants {
  /* -------------------------- Ticket Screen Constants ----------------------------- */
  // Titulo del formulario para crear incidencias en TicketScreen.
  static const tituloFormularioIncidencias = 'Señalar incidencias';

  // Titulo del listado de incidencias que se genera en el panel derecho de TicketScreen.
  static const listadoIncidenciasTitulo = 'Incidencias';

  // Titulo del aviso que aparece encima del boton de "Señalar incidencia"
  static const avisoFormularioIncidencias1 = "Antes de señalar:";

  // Cuerpo de texto del aviso que aparece encima del boton de "Señalar incidencia"
  static const avisoFormularioIncidencias2 =
      "Recuerde controlar las incidencias actualmente en progreso.";

  /* -------------------------- Record Item Constants ----------------------------- */
  static const urlAPI = 'http://localhost:8888';
  static const estadoPendiente = "PENDIENTE";
  static const estadoResuelta = "RESUELTA";
  static const estadoEnProgreso = "EN PROGRESO";
  static const estadoCancelada = "CANCELADA";

  /* -------------------------- Auth Gate class ----------------------------- */
  // Imagen para el hero
  static const imagenHero = 'assets/img/reaktor-logo.png';
  // Mensaje de bienvenida que aparece encima del boton de autenticacion.
  static const mensajeBienvenida = "¡Bienvenido a Reaktor!";
  // Mensaje que aparece debajo del boton de "Autenticacion con google"
  static const subtituloLogin = "Acceso limitado: Solo personal autorizado.";

  // Avisos footer login.
  static const avisoParrafo1 =
      "Esta plataforma es de acceso exclusivo para usuarios autorizados. El acceso a este sistema está estrictamente limitado a aquellas personas a quienes se les ha concedido autorización expresa, conforme a los términos y condiciones establecidos por la administración. Cualquier intento de ingresar sin la debida autorización constituye una infracción a las políticas de seguridad de la plataforma.";

  static const avisoParrafo2 =
      "Todos los intentos de autenticación y las actividades realizadas dentro del sistema son registrados y analizados con fines de seguridad. Estos registros pueden incluir información sobre el dispositivo utilizado, direcciones IP y el historial de intentos, y serán revisados regularmente para identificar posibles actividades no autorizadas o fraudulentas. La recopilación y análisis de esta información están diseñados para proteger la integridad y confidencialidad de los datos de la plataforma y sus usuarios autorizados.";

  static const avisoParrafo3 =
      "Cualquier intento de acceso no autorizado o actividad sospechosa puede resultar en acciones disciplinarias o legales conforme a las leyes vigentes. Si usted no cuenta con la autorización pertinente, se le solicita abstenerse de intentar acceder a esta plataforma. Su uso está restringido exclusivamente a personas autorizadas; cualquier otro uso es considerado una violación de la seguridad del sistema.";
}
