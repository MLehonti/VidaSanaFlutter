import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'http://192.168.0.12:8080/api'; // Cambia a tu IP

  Future<List<dynamic>> obtenerEspecialidades() async {
    final response = await http.get(Uri.parse('$apiUrl/especialidades'));
    if (response.statusCode == 200) {
      // Decodificar manualmente en UTF-8 para interpretar los caracteres correctamente
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error al obtener especialidades');
    }
  }

  Future<List<dynamic>> obtenerUsuariosPorEspecialidad(int especialidadId) async {
    final response = await http.get(Uri.parse('$apiUrl/asignaciones/usuarios-por-especialidad/$especialidadId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  Future<void> crearCita(Map<String, dynamic> cita) async {
    final response = await http.post(
      Uri.parse('$apiUrl/citas/crear'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cita),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al crear cita');
    }
  }


 Future<List<dynamic>> obtenerCitasPorUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('$apiUrl/citas/usuario/$usuarioId'));
    if (response.statusCode == 200) {
      // Decodificar manualmente en UTF-8 para interpretar los caracteres correctamente
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error al obtener citas');
    }
  }
}
