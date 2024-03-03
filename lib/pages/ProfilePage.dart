// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posting_app/pages/EditProfilePage.dart';
import 'package:posting_app/main.dart';
import '../controllers/ApiService.dart';
import '../controllers/UserDTO.dart';
import '../controllers/PublicationDTO.dart';
import 'PublicationDetailsPage.dart';

/// Clase que representa la página de perfil.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  /// Método que crea el estado de la página de perfil.
  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

/// Clase que maneja el estado de la página de perfil.
class _ProfilePageState extends State<ProfilePage> {
  late int userId;
  late int loggedInUserId;
  late Future<UserDTO> userFuture;
  late Future<List<PublicationDTO>> publicationsFuture = Future.value([]);
  bool isFollowing = false;
  int followersCount = 0;
  int followingCount = 0;

  /// Método que se ejecuta cuando el estado de la página cambia.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userId = args['userId'];
    loggedInUserId = MyApp.loggedInUser!.userId!;

    userFuture = ApiService().getUserById(userId);
    _updatePublications();
    _updateIsFollowing();
    _updateFollowersCount();
    _updateFollowingCount();
  }

  /// Método que actualiza las publicaciones.
  Future<void> _updatePublications() async {
    try {
      List<PublicationDTO> updatedPublications =
          await ApiService().getPublicationsByUserId(userId);

      if (mounted) {
        setState(() {
          publicationsFuture = Future.value(updatedPublications);
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating publications: $error');
      }
    }
  }

  /// Método que actualiza si el usuario está siguiendo a otro usuario.
  Future<void> _updateIsFollowing() async {
    try {
      bool following = await ApiService().isFollowing(loggedInUserId, userId);

      if (mounted) {
        setState(() {
          isFollowing = following;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating isFollowing: $error');
      }
    }
  }

  /// Método que alterna el estado de seguir a otro usuario.
  Future<void> _toggleFollowStatus() async {
    try {
      if (isFollowing) {
        await ApiService().unfollowUser(loggedInUserId, userId);
      } else {
        await ApiService().followUser(loggedInUserId, userId);
      }

      _updatePublications();
      _updateIsFollowing();
      _updateFollowersCount();
      _updateFollowingCount();
    } catch (error) {
      if (kDebugMode) {
        print('Error toggling follow status: $error');
      }
    }
  }

  /// Método que actualiza el número de seguidores.
  Future<void> _updateFollowersCount() async {
    try {
      List<UserDTO> followers = await ApiService().getFollowersByUserId(userId);

      if (mounted) {
        setState(() {
          followersCount = followers.length;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating followers count: $error');
      }
    }
  }

  /// Método que actualiza el número de seguidos.
  Future<void> _updateFollowingCount() async {
    try {
      List<UserDTO> following = await ApiService().getFollowingByUserId(userId);

      if (mounted) {
        setState(() {
          followingCount = following.length;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating following count: $error');
      }
    }
  }

  /// Método que construye la página de perfil.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserDTO>(
        future: userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.hasError) {
            return const Center(
              child: Text('Error loading profile'),
            );
          } else {
            UserDTO user = userSnapshot.data!;

            return FutureBuilder<List<PublicationDTO>>(
              future: publicationsFuture,
              builder: (context, publicationsSnapshot) {
                if (publicationsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (publicationsSnapshot.hasError) {
                  return const Center(
                    child: Text('Error loading publications'),
                  );
                } else {
                  List<PublicationDTO> publications =
                      publicationsSnapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (() {
                            try {
                              return utf8.decode(user.userName.runes.toList());
                            } catch (e) {
                              return user.userName;
                            }
                          })(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'Email: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '${(() {
                                  try {
                                    return utf8
                                        .decode(user.email.runes.toList());
                                  } catch (e) {
                                    return user.email;
                                  }
                                })()}',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'Description: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '${(() {
                                  try {
                                    return utf8.decode(
                                        user.description.runes.toList());
                                  } catch (e) {
                                    return user.description;
                                  }
                                })()}',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/login');
                                },
                                child: const Text('Logout'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 50),
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromARGB(255, 50, 42, 59),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (userId == loggedInUserId)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfilePage(
                                            user: MyApp.loggedInUser!),
                                        settings: RouteSettings(
                                          arguments: MyApp.loggedInUser!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Edit Profile'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 50),
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 119, 0, 255),
                                  ),
                                ),
                              ),
                            if (userId != loggedInUserId)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: userId == loggedInUserId
                                      ? null
                                      : _toggleFollowStatus,
                                  child: Text(
                                    (isFollowing ? 'Unfollow' : 'Follow'),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 50),
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 119, 0, 255),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Followers: $followersCount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Following: $followingCount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Publications:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (PublicationDTO publication in publications)
                          _buildPublicationTile(context, publication),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  /// Método que construye una publicación.
  Widget _buildPublicationTile(
      BuildContext context, PublicationDTO publication) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PublicationDetailsPage(
                publicationId: publication.publicationId!,
              ),
            ),
          );
        },
        child: ListTile(
          title: Text(publication.text ?? ''),
          subtitle: Text(
            DateFormat('dd-MM-yyyy HH:mm').format(publication.creationDate!) ==
                    DateFormat('dd-MM-yyyy HH:mm')
                        .format(publication.editionDate!)
                ? 'Created: ${DateFormat('dd-MM-yyyy HH:mm').format(publication.creationDate!)}'
                : 'Edited: ${DateFormat('dd-MM-yyyy HH:mm').format(publication.editionDate!)}',
          ),
        ),
      ),
    );
  }
}
