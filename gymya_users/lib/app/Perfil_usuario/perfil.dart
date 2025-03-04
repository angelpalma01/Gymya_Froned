import 'package:flutter/material.dart';

class PerfilScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final String membresiaId;

  const PerfilScreen({
    super.key,
    required this.token,
    required this.user,
    required this.membresiaId,
  });

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simular una carga inicial (puedes eliminar esto si no es necesario)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Imagen de perfil
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(widget.user['imagen']),
                  ),
                  const SizedBox(height: 20),
                  // Nombre completo con ShaderMask
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.purple, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      widget.user['nombre_completo'],
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: screenWidth * 0.1, // Tamaño de fuente dinámico
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Detalles adicionales
                  Card(
                    color: Colors.grey[900],
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // ID del usuario
                          ListTile(
                            leading: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [Colors.purple, Colors.red],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.white, // Color base para el ícono
                              ),
                            ),
                            title: const Text(
                              'ID de Usuario',
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              widget.user['_id'],
                              style: const TextStyle(
                                color: Colors.white70, // Texto más claro
                              ),
                            ),
                          ),
                          const Divider(),
                          // Correo electrónico
                          ListTile(
                            leading: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [Colors.purple, Colors.red],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Icon(
                                Icons.email,
                                color: Colors.white, // Color base para el ícono
                              ),
                            ),
                            title: const Text(
                              'Correo',
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              widget.user['email'],
                              style: const TextStyle(
                                color: Colors.white70, // Texto más claro
                              ),
                            ),
                          ),
                          const Divider(),
                          // Teléfono (si está disponible)
                          ListTile(
                            leading: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [Colors.purple, Colors.red],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white, // Color base para el ícono
                              ),
                            ),
                            title: const Text(
                              'Teléfono',
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              widget.user['telefono'] ?? 'No proporcionado',
                              style: TextStyle(
                                color: widget.user['telefono'] == null
                                    ? Colors.grey
                                    : Colors.white70, // Texto más claro
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}