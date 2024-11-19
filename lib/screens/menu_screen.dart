import 'package:flutter/material.dart';
import 'especialidades_screen.dart'; // Asegúrate de que la ruta es correcta

import 'package:flutter/material.dart';
import 'especialidades_screen.dart'; // Importar EspecialidadesScreen
import 'citas_usuario_screen.dart'; // Importa la pantalla de citas

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menú Principal"),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Bienvenido al Sistema Médico",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            _buildMenuButton(
              context,
              icon: Icons.local_hospital,
              text: "Especialidades",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EspecialidadesScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.calendar_today,
              text: "Citas",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CitasUsuarioScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.history,
              text: "Ver mi historial clínico",
              onPressed: () {
                // Navegar a la pantalla de Historial Clínico
              },
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.logout,
              text: "Salir",
              onPressed: () {
                // Cerrar sesión y navegar a la pantalla de login
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required IconData icon, required String text, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white), // Color del texto cambiado a blanco
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        backgroundColor: Colors.teal[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
