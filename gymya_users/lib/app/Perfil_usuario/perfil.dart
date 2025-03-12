import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar el archivo de imagen
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP
import 'package:async/async.dart'; // Para multipart/form-data
import 'dart:convert'; // Para codificar la respuesta JSON

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
  bool isUploading = false; // Estado para manejar la carga de la imagen
  File? _selectedImage; // Archivo de imagen seleccionada
  late Map<String, dynamic> user; // Variable para almacenar el user actualizado

  @override
  void initState() {
    super.initState();
    user = widget.user; // Inicializamos el user con el valor original
    // Simular una carga inicial (puedes eliminar esto si no es necesario)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  // Función para seleccionar una imagen de la cámara o galería
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      // Llamar a la función para subir la imagen
      await _uploadImage();
    }
  }

  // Función para subir la imagen al servidor
  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      isUploading = true; // Indicamos que está subiendo
    });

    try {
      var uri = Uri.parse('https://api-gymya-api.onrender.com/api/${widget.user['_id']}/actualizarImagen'); // Actualiza la URL
      var request = http.MultipartRequest('PUT', uri);

      // Adjuntamos la imagen
      var stream = http.ByteStream(DelegatingStream.typed(_selectedImage!.openRead()));
      var length = await _selectedImage!.length();

      request.files.add(http.MultipartFile('imagen', stream, length, filename: _selectedImage!.path.split('/').last));

      // Enviar la solicitud con los headers de autenticación
      request.headers['Authorization'] = 'Bearer ${widget.token}'; 

      // Enviar la solicitud
      var response = await request.send();

      // Manejar la respuesta
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);

        // Actualizar el perfil del usuario con los nuevos datos
        setState(() {
          user['imagen'] = data['imagen'];
        });

        print('Imagen actualizada correctamente');
      } else {
        print('Error al actualizar la imagen');
      }
    } catch (e) {
      print('Error al subir la imagen: $e');
    } finally {
      setState(() {
        isUploading = false; // Terminamos de subir
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Color de la flecha
          ),
          onPressed: () {
            // Navegar de regreso a la pantalla home.dart
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      // Imagen de perfil con borde degradado
                      Container(
                        padding: const EdgeInsets.all(4), // Borde de 4px
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(100), // Borde redondeado
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : NetworkImage(user['imagen']) as ImageProvider,
                        ),
                      ),
                      // Botón de cámara sobre la imagen de perfil
                      Positioned(
                        top: 115,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.purple, Colors.red],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Abrir opciones para seleccionar imagen
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => _buildImagePickerOptions(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Nombre con gradiente
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.purple, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop, // Asegura que el gradiente se aplique correctamente
                    child: Text(
                      '${user['nombre_completo']}', // Nombre fijo
                      style: TextStyle(
                        fontSize: screenWidth * 0.08, // Tamaño de fuente dinámico
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto', // Cambia la tipografía si lo deseas
                        color: Colors.white, // Color base para el texto
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Detalles adicionales en tarjetas minimalistas
                  _buildDetailCard(
                    icon: Icons.person_outline,
                    title: 'ID de Usuario',
                    subtitle: user['_id'],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    icon: Icons.email,
                    title: 'Correo',
                    subtitle: user['email'],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    icon: Icons.phone,
                    title: 'Teléfono',
                    subtitle: user['telefono'] ?? 'No proporcionado',
                    isPhone: true,
                  ),
                ],
              ),
            ),
    );
  }

  // Opciones para seleccionar imagen desde la cámara o galería
  Widget _buildImagePickerOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera),
          title: const Text('Tomar una foto'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.camera);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Elegir de la galería'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.gallery);
          },
        ),
      ],
    );
  }

  // Widget para construir tarjetas de detalles minimalistas
  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isPhone = false,
  }) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Ícono con gradiente
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.purple, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // Cambia la tipografía si lo deseas
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isPhone && subtitle == 'No proporcionado'
                          ? Colors.grey
                          : Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Roboto', // Cambia la tipografía si lo deseas
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}