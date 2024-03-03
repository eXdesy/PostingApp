// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:posting_app/controllers/UserDTO.dart';
import 'package:posting_app/main.dart';
import '../controllers/ApiService.dart';

/// Clase que permite editar el perfil del usuario
class EditProfilePage extends StatefulWidget {
  final UserDTO user;

  const EditProfilePage({super.key, required this.user});

  /// Método que crea el estado de la página de edición de perfil
  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

/// Clase que maneja el estado de la página de edición de perfil
class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController emailController;
  late TextEditingController descriptionController;

  /// Método que inicializa el estado de la página
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: () {
      try {
        return utf8.decode(MyApp.loggedInUser!.email.runes.toList());
      } catch (e) {
        return MyApp.loggedInUser!.email;
      }
    }());
    descriptionController = TextEditingController(
      text: () {
        try {
          return utf8.decode(MyApp.loggedInUser!.description.runes.toList());
        } catch (e) {
          return MyApp.loggedInUser!.description;
        }
      }(),
    );
  }

  /// Método que construye la página de edición de perfil
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${MyApp.loggedInUser!.userName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 119, 0, 255),
              ),
              onPressed: () {
                _saveChanges();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  /// Método que guarda los cambios realizados en el perfil del usuario
  void _saveChanges() async {
    try {
      final userId = MyApp.loggedInUser!.userId;
      final newEmail = emailController.text;
      final newDescription = descriptionController.text;

      final updatedDetails =
          await ApiService().editUserDetails(userId!, newDescription, newEmail);
      if (kDebugMode) {
        print('Updated Details: $updatedDetails');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Details updated successfully!'),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This email is already in use!'),
        ),
      );
    }
  }
}
