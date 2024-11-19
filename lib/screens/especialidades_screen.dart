import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class EspecialidadesScreen extends StatefulWidget {
  @override
  _EspecialidadesScreenState createState() => _EspecialidadesScreenState();
}

class _EspecialidadesScreenState extends State<EspecialidadesScreen> {
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();

  List<dynamic> especialidades = [];
  List<dynamic> usuarios = [];
  int? selectedEspecialidadId;

  @override
  void initState() {
    super.initState();
    cargarEspecialidades();
  }

  void cargarEspecialidades() async {
    try {
      final data = await apiService.obtenerEspecialidades();
      setState(() {
        especialidades = data;
      });
    } catch (e) {
      print('Error al cargar especialidades: $e');
    }
  }

  void cargarUsuariosPorEspecialidad(int especialidadId) async {
    setState(() {
      selectedEspecialidadId = especialidadId;
      usuarios = []; // Limpiar usuarios al cambiar de especialidad
    });
    try {
      final data = await apiService.obtenerUsuariosPorEspecialidad(especialidadId);
      setState(() {
        usuarios = data;
      });
    } catch (e) {
      print('Error al cargar usuarios: $e');
    }
  }

  void seleccionarFicha(dynamic usuario) async {
    try {
      final usuarioId = await authService.getUsuarioId();
      if (usuarioId == null) return;

      final cita = {
        "usuarioId": usuarioId,
        "medicoId": usuario['usuarioId'],
        "especialidadId": selectedEspecialidadId,
        "turnoId": usuario['turnoId'],
        "diaId": usuario['diaId'],
        "horario": usuario['horario'],
        "nombreUsuarioLogeado": usuario['nombreUsuario'],
        "fecha": usuario['fecha'],
        "horarioId": usuario['horarioId'],
      };

      await apiService.crearCita(cita);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita creada exitosamente')),
      );
    } catch (e) {
      print('Error al crear cita: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear cita')),
      );
    }
  }

  // Método para normalizar texto eliminando acentos y tildes
  String normalizarTexto(String texto) {
    return texto
        .replaceAll(RegExp(r'[ÁÀÂÄ]'), 'A')
        .replaceAll(RegExp(r'[áàâä]'), 'a')
        .replaceAll(RegExp(r'[ÉÈÊË]'), 'E')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[ÍÌÎÏ]'), 'I')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[ÓÒÔÖ]'), 'O')
        .replaceAll(RegExp(r'[óòôö]'), 'o')
        .replaceAll(RegExp(r'[ÚÙÛÜ]'), 'U')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[Ñ]'), 'N')
        .replaceAll(RegExp(r'[ñ]'), 'n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Especialidades'),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Seleccione una Especialidad",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: especialidades.length,
                itemBuilder: (context, index) {
                  final especialidad = especialidades[index];
                  return Card(
                    color: Colors.teal[50],
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        normalizarTexto(especialidad['nombre']), // Aplicamos normalización aquí
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            cargarUsuariosPorEspecialidad(especialidad['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Ver Médicos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (selectedEspecialidadId != null) Expanded(child: _buildUsuariosTable())
          ],
        ),
      ),
    );
  }

  Widget _buildUsuariosTable() {
    return usuarios.isEmpty
        ? Center(
            child: Text(
              'No hay usuarios para esta especialidad',
              style: TextStyle(color: Colors.teal[800], fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      usuario['usuario'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal[800],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Turno: ${usuario['turno']}'),
                        Text('Horario: ${usuario['horario']}'),
                        Text('Día: ${usuario['dia']}'),
                        Text('Fecha: ${usuario['fecha']}'),
                        Text(
                          'Disponibilidad: ${usuario['disponibilidad'] ? 'Disponible' : 'No Disponible'}',
                          style: TextStyle(
                            color: usuario['disponibilidad']
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: usuario['disponibilidad']
                          ? () => seleccionarFicha(usuario)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Seleccionar Ficha',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
