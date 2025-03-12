import 'package:flutter/material.dart';
import 'dart:io';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final File? selectedImage;
  final bool isUploading;
  final VoidCallback onCameraTap;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.selectedImage,
    required this.isUploading,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
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
            backgroundImage: selectedImage != null
                ? FileImage(selectedImage!)
                : NetworkImage(imageUrl) as ImageProvider,
          ),
        ),
        if (isUploading)
          Positioned(
            top: 50,
            right: 50,
            child: CircularProgressIndicator(),
          ),
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
              onPressed: onCameraTap,
            ),
          ),
        ),
      ],
    );
  }
}