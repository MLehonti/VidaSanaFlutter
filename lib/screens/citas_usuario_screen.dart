import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class CitasUsuarioScreen extends StatefulWidget {
  @override
  _CitasUsuarioScreenState createState() => _CitasUsuarioScreenState();
}

class _CitasUsuarioScreenState extends State<CitasUsuarioScreen> {
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();

  List<dynamic> citas = [];
  String fechaActual = '';

  @override
  void initState() {
    super.initState();
    cargarCitas();
    fechaActual = obtenerFechaActual();
  }

  // Método para cargar las citas del usuario logueado
  void cargarCitas() async {
    try {
      final usuarioId = await authService.getUsuarioId();
      if (usuarioId != null) {
        final data = await apiService.obtenerCitasPorUsuario(usuarioId);
        setState(() {
          citas = data;
        });
      } else {
        print("Usuario ID no encontrado");
      }
    } catch (e) {
      print("Error al cargar citas: $e");
    }
  }

  // Método para obtener la fecha actual en formato legible
  String obtenerFechaActual() {
    final hoy = DateTime.now();
    return "${hoy.day}/${hoy.month}/${hoy.year}";
  }

  // Método para obtener la ubicación de acuerdo a la especialidad
  String obtenerUbicacion(String especialidad) {
    switch (especialidad.trim().toLowerCase()) {
      case 'cardiología':
        return 'Tercer piso, Sala 2';
      case 'pediatría':
        return 'Tercer piso, Sala 3';
      case 'medicina general':
        return 'Tercer piso, Sala 1';
      case 'laboratorios':
        return 'Primer piso, Sala 1';
      case 'psicología':
        return 'Primer piso, Sala 2';
      case 'dermatología':
        return 'Primer piso, Sala 3';
      default:
        return 'Ubicación no especificada';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Citas'),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fecha Actual: $fechaActual",
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 20),
            citas.isEmpty
                ? Center(
                    child: Text(
                      'No tienes citas programadas.',
                      style: TextStyle(color: Colors.teal[800], fontSize: 16),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: citas.length,
                      itemBuilder: (context, index) {
                        final cita = citas[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          color: Colors.teal[50],
                          child: ListTile(
                            title: Text(
                              cita['especialidad'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fecha: ${fechaActual}'), // Muestra la fecha actual
                                Text('Hora: ${cita['horario']}'),
                                Text('Ubicación: ${obtenerUbicacion(cita['especialidad'])}'),
                                Text('Usuario Logeado: ${cita['nombreUsuarioLogeado']}'),
                                Text('Turno: ${cita['turno']}'),
                                Text('Día: ${cita['dia']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
