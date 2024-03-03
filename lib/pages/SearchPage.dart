// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:posting_app/controllers/ApiService.dart';
import 'package:posting_app/controllers/UserDTO.dart';

/// Página de búsqueda de usuarios.
class SearchPage extends StatefulWidget {
  // ignore: use_super_parameters
  const SearchPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

/// Estado de la página de búsqueda de usuarios.
class _SearchPageState extends State<SearchPage> {
  List<UserDTO> allUsers = [];
  List<UserDTO> searchedUsers = [];

  /// Inicializa el estado de la página de búsqueda de usuarios.
  @override
  void initState() {
    super.initState();
    loadAllUsers();
  }

  // Función para cargar todos los usuarios
  Future<void> loadAllUsers() async {
    try {
      List<UserDTO> result = await ApiService().getAllUsers();
      setState(() {
        allUsers = result;
        searchedUsers = result;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading all users: $e');
      }
    }
  }

  // Función para realizar la búsqueda por nombre
  void searchByName(String query) {
    setState(() {
      searchedUsers = allUsers
          .where((user) =>
              user.userName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// Método que construye la interfaz de la página de búsqueda de usuarios.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              onChanged: (query) => searchByName(query),
              decoration: const InputDecoration(
                labelText: 'Search users by name',
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: searchedUsers.isEmpty
                  ? const Center(
                      child: Text('No users found.'),
                    )
                  : ListView.builder(
                      itemCount: searchedUsers.length,
                      itemBuilder: (context, index) {
                        final UserDTO user = searchedUsers[index];

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Color.fromARGB(255, 119, 0, 255),
                          child: ListTile(
                            title: Text(
                              user.userName,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              user.description,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/profile',
                                arguments: {'userId': user.userId},
                              );
                            },
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
