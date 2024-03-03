// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:posting_app/controllers/ApiService.dart';
import 'package:posting_app/controllers/UserDTO.dart';

/// Clase RegisterPage que representa la página de registro de la aplicación.
class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  RegisterPage({super.key});

  /// Método que construye la interfaz de la página de registro.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(161, 0, 255, 1),
              Color.fromRGBO(69, 0, 87, 1),
            ],
            stops: [0, 1],
            center: Alignment.center,
            radius: 1,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                    height: 0),
                const Text(
                  'Posting...',
                  style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 100),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                          backgroundColor: Colors.white,
                          foregroundColor: Color.fromARGB(255, 119, 0, 255),
                        ),
                      child: const Text('Register'),
                      onPressed: () async {
                        try {
                          await ApiService().registerUser(
                            UserDTO(
                              userName: usernameController.text,
                              password: passwordController.text,
                              email: emailController.text,
                              description: descriptionController.text,
                              creationDate: DateTime.now(),
                            ),
                          );
                          await ApiService().loginWithJwt();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, '/login');
                        } catch (e) {
                          if (passwordController.text.length < 8) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password must be at least 8 characters'),
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to register')),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(width: 15), // Espacio entre los botones
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                        backgroundColor: Colors.white,
                        foregroundColor: Color.fromARGB(255, 119, 0, 255),
                      ),
                      child: Text('Back'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
