// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posting_app/controllers/ApiService.dart';
import 'package:posting_app/controllers/PublicationDTO.dart';
import 'package:posting_app/pages/SearchPage.dart';
import 'package:posting_app/controllers/UserDTO.dart';
import 'package:posting_app/main.dart';

/// Clase que representa la página principal de la aplicación.
class CharacterCounter extends StatefulWidget {
  final TextEditingController textController;

  const CharacterCounter({super.key, required this.textController});

  @override
  // ignore: library_private_types_in_public_api
  _CharacterCounterState createState() => _CharacterCounterState();
}

/// Clase que maneja el estado del contador de caracteres.
class _CharacterCounterState extends State<CharacterCounter> {
  late int remainingCharacters;

  /// Método que inicializa el estado del contador de caracteres.
  @override
  void initState() {
    super.initState();
    remainingCharacters = calculateRemainingCharacters();
    widget.textController.addListener(updateCounter);
  }

  /// Método que libera los recursos utilizados por el estado del contador de caracteres.
  @override
  void dispose() {
    widget.textController.removeListener(updateCounter);
    super.dispose();
  }

  /// Método que actualiza el contador de caracteres.
  void updateCounter() {
    setState(() {
      remainingCharacters = calculateRemainingCharacters();
    });
  }

  /// Método que calcula los caracteres restantes.
  int calculateRemainingCharacters() {
    return 250 - widget.textController.text.length;
  }

  /// Método que construye el contador de caracteres.
  @override
  Widget build(BuildContext context) {
    return Text('$remainingCharacters/250',
        style: TextStyle(
          color: remainingCharacters >= 0 ? Colors.black : Colors.red,
        ));
  }
}

/// Clase que maneja el estado de la página principal de la aplicación.
class HomePage extends StatefulWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key}) : super(key: key);

  /// Método que crea el estado de la página principal de la aplicación.
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

/// Clase que maneja el estado de la página principal de la aplicación.
class _HomePageState extends State<HomePage> {
  final TextEditingController publicationController = TextEditingController();
  List<PublicationDTO> allPublications = [];
  List<PublicationDTO> followingPublications = [];

  /// Método que inicializa el estado de la página principal de la aplicación.
  @override
  void initState() {
    super.initState();
    loadPublications();
  }

  /// Método que construye la página principal de la aplicación.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Posting...',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 98, 0, 209),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/profile', arguments: {
                  'userId': MyApp.loggedInUser!.userId,
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                loadPublications();
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'All Publications',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Following Publications',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildPublicationsList(allPublications),
            buildPublicationsList(followingPublications),
          ],
        ),
      ),
    );
  }

  /// Método que construye la lista de publicaciones.
  Widget buildPublicationsList(List<PublicationDTO> publications) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Expanded(
            child: publications.isEmpty
                ? const Center(
                    child: Text('No publications available.'),
                  )
                : ListView.builder(
                    itemCount: publications.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      final int reversedIndex = publications.length - 1 - index;
                      final PublicationDTO publication =
                          publications[reversedIndex];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/publicationDetails',
                              arguments: {
                                'publicationId': publication.publicationId
                              },
                            );
                          },
                          title: Text(publication.text ?? ''),
                          subtitle: FutureBuilder<UserDTO>(
                            future:
                                ApiService().getUserById(publication.authorId!),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('Author: Loading...');
                              } else if (userSnapshot.hasError) {
                                return const Text(
                                    'Author: Error loading author');
                              } else {
                                UserDTO author = userSnapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/profile',
                                              arguments: {
                                                'userId': author.userId
                                              },
                                            );
                                          },
                                          child: Text(
                                            author.userName,
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 119, 0, 255),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (publication.creationDate ==
                                            publication.editionDate)
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Created: ${DateFormat('dd-MM-yyyy HH:mm').format(publication.creationDate!)}',
                                            ),
                                          ),
                                        if (publication.creationDate !=
                                            publication.editionDate)
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Edited: ${DateFormat('dd-MM-yyyy HH:mm').format(publication.editionDate!)}',
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: publicationController,
                  decoration: const InputDecoration(
                    labelText: 'Create a new publication',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 119, 0, 255),
                    ),
                    child: const Text('Post'),
                    onPressed: () async {
                      try {
                        if (MyApp.loggedInUser == null ||
                            MyApp.loggedInUser!.userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('User is not authenticated')),
                          );
                          return;
                        }

                        if (publicationController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Publication text is empty')),
                          );
                          return;
                        }

                        if (publicationController.text.length > 250) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Publication text exceeds 250 characters')),
                          );
                          return;
                        }

                        PublicationDTO newPublication = PublicationDTO(
                          text: publicationController.text,
                          creationDate: DateTime.now(),
                          editionDate: DateTime.now(),
                        );

                        await ApiService().createPublication(
                            newPublication, MyApp.loggedInUser!.userId!);

                        publicationController.clear();

                        loadPublications();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'There was an unexpected error, try logging in again'),
                          ),
                        );
                      }
                    },
                  ),
                ]
              ),
            ],
          ),
          const SizedBox(height: 10),
          CharacterCounter(textController: publicationController),
        ],
      ),
    );
  }

  /// Método que carga las publicaciones.
  Future<void> loadPublications() async {
    try {
      List<PublicationDTO> loadedAllPublications =
          await ApiService().getAllPublications();
      setState(() {
        allPublications = loadedAllPublications;
      });

      List<PublicationDTO> loadedFollowingPublications = await ApiService()
          .getPublicationsByUserIdWithFollowing(MyApp.loggedInUser!.userId!);
      setState(() {
        followingPublications = loadedFollowingPublications;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error during loadPublications: $e');
      }
    }
  }
}
