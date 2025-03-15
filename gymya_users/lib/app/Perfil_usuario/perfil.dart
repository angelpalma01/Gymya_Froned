import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar el archivo de imagen
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP
import 'package:async/async.dart'; // Para multipart/form-data
import 'dart:convert'; // Para codificar la respuesta JSON
import 'widgets/profile_image.dart';
import 'widgets/detail_card.dart';
import 'package:gymya_users/app/Home/home.dart';

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Color de la flecha
          ),
          onPressed: () {
            // Navegar de regreso a la pantalla home.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(
                  token: widget.token,
                  user: widget.user,
                  membresiaId: widget.membresiaId,
                ),
              ),
            );
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
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ProfileImage(
                        imageUrl: user['imagen']  ?? 'https://via.placeholder.com/150',
                        selectedImage: _selectedImage,
                        isUploading: isUploading,
                        onCameraTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => _buildImagePickerOptions(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                  DetailCard(
                    icon: Icons.person_outline,
                    title: 'ID de Usuario',
                    subtitle: user['_id'],
                  ),
                  const SizedBox(height: 16),
                  DetailCard(
                    icon: Icons.email,
                    title: 'Correo',
                    subtitle: user['email'],
                  ),
                  const SizedBox(height: 16),
                  DetailCard(
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
}