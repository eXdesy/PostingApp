import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CommentDTO.dart';
import 'UserDTO.dart';
import 'PublicationDTO.dart';

/// Clase que contiene los métodos para realizar solicitudes a la API
class ApiService {
  final String baseUrl =
      "http://192.168.0.18:8080"; // Cambia esto por la URL de tu API
  String? token;

  /// Método para iniciar sesión con JWT
  /// Future es un objeto que representa un valor o error que estará disponible en el futuro
  Future<void> loginWithJwt() async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'lMCvj7Sirkk41OpuXDBKoSA1YeQ4aTeHmP4gzoyoaLk=', // Cambia esto por tu token de autentificación
      },
      body: jsonEncode({
        'username': 'test', // Cambia esto por tu usuario de autentificación
        'password': 'test', // Cambia esto por tu contraseña de autentificación
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      token =
          data['token']; // Guarda el token para usarlo en futuras solicitudes
    } else {
      throw Exception('Failed to login with JWT');
    }
  }

  /// Método para registrar un usuario, espera a que se devuelva una respuesta y por eso es async
  /// Future<void> indica que el método no devuelve ningún valor
  /// UserDTO es el objeto que se enviará en el cuerpo de la solicitud
  Future<void> registerUser(UserDTO userDTO) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt(); // Esperar a que se complete loginWithJwt
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userName': userDTO.userName,
          'email': userDTO.email,
          'password': userDTO.password,
          'description': userDTO.description,
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during registerUser: $e');
      }
      throw Exception('Failed to register user');
    }
  }

  /// Metodo para el login de un usuario
  /// Future<UserDTO> indica que el método devolverá un objeto UserDTO en el futuro
  /// String username y String password son los datos que se enviarán en el cuerpo de la solicitud
  Future<UserDTO> loginUser(String username, String password) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userName': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        return UserDTO.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during loginUser: $e');
      }
      throw Exception('Failed to login');
    }
  }

  /// Método para crear una publicación
  /// Future<void> indica que el método no devuelve ningún valor
  /// PublicationDTO es el objeto que se enviará en el cuerpo de la solicitud
  Future<void> createPublication(
      PublicationDTO publicationDTO, int userId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/user/$userId/publication'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'text': publicationDTO.text,
          'creationDate': publicationDTO.creationDate?.toIso8601String(),
          'editionDate': publicationDTO.editionDate?.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print(response.body);
        }
      } else {
        if (kDebugMode) {
          print('Request body: ${jsonEncode({'text': publicationDTO.text})}');
        }
        throw Exception(
            'Failed to create publication. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during createPublication: $e');
      }
      throw Exception('Failed to create publication $e');
    }
  }

  /// Método para obtener todas las publicaciones
  /// Future<List<PublicationDTO>> indica que el método devolverá una lista de objetos PublicationDTO en el futuro
  Future<List<PublicationDTO>> getAllPublications() async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt(); // Esperar a que se complete loginWithJwt
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/publication'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));

        List<PublicationDTO> publications = body
            .map(
              (dynamic item) => PublicationDTO.fromJson(item),
            )
            .toList();
        return publications;
      } else {
        throw Exception(
            'Failed to get publications. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during getAllPublications: $e');
      }
      throw Exception('Failed to get publications');
    }
  }

  /// Método para obtener un usuario por su ID
  /// Future<UserDTO> indica que el método devolverá un objeto UserDTO en el futuro
  /// int userId es el ID del usuario que se enviará en la URL de la solicitud
  Future<UserDTO> getUserById(int userId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt(); // Esperar a que se complete loginWithJwt
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return UserDTO.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get user by ID. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during getUserById: $e');
      }
      throw Exception('Failed to get user by ID');
    }
  }

  /// Método para eliminar una publicación
  /// Future<void> indica que el método no devuelve ningún valor
  /// int userId y int publicationId son los IDs del usuario y la publicación que se enviarán en la URL de la solicitud
  Future<void> deletePublication(int userId, int publicationId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/user/$userId/publication/$publicationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        if (kDebugMode) {
          print(response.body);
        }
      } else {
        throw Exception(
            'Failed to delete publication. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during deletePublication: $e');
      }
      throw Exception('Failed to delete publication');
    }
  }

  /// Método para obtener las publicaciones de un usuario
  /// Future<List<PublicationDTO>> indica que el método devolverá una lista de objetos PublicationDTO en el futuro
  /// int userId es el ID del usuario que se enviará en la URL de la solicitud
  Future<List<PublicationDTO>> getPublicationsByUserId(int userId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt(); // Esperar a que se complete loginWithJwt
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/user/$userId/publications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));

        List<PublicationDTO> publications = body
            .map(
              (dynamic item) => PublicationDTO.fromJson(item),
            )
            .toList();
        return publications;
      } else {
        throw Exception(
            'Failed to get publications. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during getPublicationsByUserId: $e');
      }
      throw Exception('Failed to get publications by user ID');
    }
  }

  /// Método para editar una publicación
  /// Future<PublicationDTO> indica que el método devolverá un objeto PublicationDTO en el futuro
  /// int userId y int publicationId son los IDs del usuario y la publicación que se enviarán en la URL de la solicitud
  /// PublicationDTO publicationDTO es el objeto que se enviará en el cuerpo de la solicitud
  Future<PublicationDTO> editPublication(
      int userId, int publicationId, PublicationDTO publicationDTO) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/user/$userId/publication/$publicationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'text': publicationDTO.text,
        }),
      );

      if (response.statusCode == 200) {
        final updatedPublication =
            PublicationDTO.fromJson(jsonDecode(response.body));
        return updatedPublication;
      } else {
        throw Exception(
            'Failed to edit publication. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during editPublication: $e');
      }
      throw Exception('Failed to edit publication');
    }
  }

  /// Método para obtener una publicación por su ID
  /// Future<PublicationDTO> indica que el método devolverá un objeto PublicationDTO en el futuro
  /// int publicationId es el ID de la publicación que se enviará en la URL de la solicitud
  Future<PublicationDTO> getPublicationById(int publicationId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/publication/$publicationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return PublicationDTO.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get publication by ID. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during getPublicationById: $e');
      }
      throw Exception('Failed to get publication by ID');
    }
  }

  /// Método para obtener las publicaciones de un usuario y las de las personas a las que sigue
  /// Future<List<PublicationDTO>> indica que el método devolverá una lista de objetos PublicationDTO en el futuro
  /// int userId es el ID del usuario que se enviará en la URL de la solicitud
  Future<List<UserDTO>> getFollowingByUserId(int userId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/user/$userId/following'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));

        List<UserDTO> followingList = body
            .map(
              (dynamic item) => UserDTO.fromJson(item),
            )
            .toList();
        return followingList;
      } else {
        throw Exception(
            'Failed to get following list. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during getFollowingByUserId: $e');
      }
      throw Exception('Failed to get following list');
    }
  }

  /// Método para obtener las publicaciones de un usuario y las de las personas a las que sigue
  /// Future<List<PublicationDTO>> indica que el método devolverá una lista de objetos PublicationDTO en el futuro
  /// int userId es el ID del usuario que se enviará en la URL de la solicitud
  Future<List<PublicationDTO>> getPublicationsByUserIdWithFollowing(
      int userId) async {
    try {
      // Obtener las personas a las que sigue el usuario
      List<UserDTO> followingUsers = await getFollowingByUserId(userId);

      print('Following users: $followingUsers');

      // Obtener las publicaciones del usuario
      List<PublicationDTO> userPublications =
          await getPublicationsByUserId(userId);

      // Obtener las publicaciones de las personas a las que sigue, excluyendo las del usuario actual
      List<PublicationDTO> followingPublications = [];

      for (UserDTO user in followingUsers) {
        if (user.userId != userId) {
          List<PublicationDTO> userFollowingPublications =
              await getPublicationsByUserId(user.userId!);
          followingPublications.addAll(userFollowingPublications);
        }
      }

      // Filtrar las publicaciones del usuario actual
      List<PublicationDTO> filteredUserPublications = userPublications
          .where((publication) => publication.authorId != userId)
          .toList();

      // Combinar las dos listas de publicaciones
      List<PublicationDTO> allPublications = [
        ...filteredUserPublications,
        ...followingPublications
      ];

      return allPublications;
    } catch (e) {
      throw Exception('Error during getPublicationsByUserIdWithFollowing: $e');
    }
  }

  /// Método para obtener las publicaciones de un usuario y las de las personas a las que sigue
  /// Future<List<PublicationDTO>> indica que el método devolverá una lista de objetos PublicationDTO en el futuro
  /// int userId es el ID del usuario que se enviará en la URL de la solicitud
  Future<void> followUser(int followerId, int followedId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/user/$followerId/follow/$followedId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Successfully followed user.');
        }
      } else {
        throw Exception(
            'Failed to follow user. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during followUser: $e');
      }
      throw Exception('Failed to follow user');
    }
  }

  /// Método para dejar de seguir a un usuario
  /// Future<void> indica que el método no devuelve ningún valor
  /// int followerId y int followedId son los IDs del usuario que se enviarán en la URL de la solicitud
  Future<void> unfollowUser(int followerId, int followedId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/user/$followerId/unfollow/$followedId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        if (kDebugMode) {
          print('Successfully unfollowed user.');
        }
      } else {
        throw Exception(
            'Failed to unfollow user. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during unfollowUser: $e');
      }
      throw Exception('Failed to unfollow user');
    }
  }

  /// Método para comprobar si un usuario sigue a otro
  /// Future<bool> indica que el método devolverá un valor booleano en el futuro
  /// int followerId y int followedId son los IDs del usuario que se enviarán en la URL de la solicitud
  Future<bool> isFollowing(int followerId, int followedId) async {
    try {
      List<UserDTO> followingUsers = await getFollowingByUserId(followerId);
      return followingUsers.any((user) => user.userId == followedId);
    } catch (e) {
      if (kDebugMode) {
        print('Error during isFollowing: $e');
      }
      throw Exception('Failed to check if user is following');
    }
  }

  /// Método para editar los detalles de un usuario
  /// Future<Map<String, String>> indica que el método devolverá un mapa de cadenas en el futuro
  /// int userId es el ID del usuario que se enviará en la URL de la solicitud
  /// String newDescription y String newEmail son los datos que se enviarán en el cuerpo de la solicitud
  Future<Map<String, String>> editUserDetails(
      int userId, String newDescription, String newEmail) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/$userId/edit/details'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'newDescription': newDescription,
          'newEmail': newEmail,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody.map((key, value) => MapEntry(key, value as String));
      } else {
        throw Exception('Failed to edit user details');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error editing user details: $e');
      }
      throw Exception('Failed to edit user details: $e');
    }
  }

  /// Método para obtener los comentarios de una publicación
  /// Future<List<CommentDTO>> indica que el método devolverá una lista de objetos CommentDTO en el futuro
  /// int publicationId es el ID de la publicación que se enviará en la URL de la solicitud
  Future<List<CommentDTO>> getCommentsByPublicationId(int publicationId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/publication/$publicationId/comments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<CommentDTO> comments = (jsonDecode(response.body) as List)
            .map((comment) => CommentDTO.fromJson(comment))
            .toList();

        return comments;
      } else {
        throw Exception(
            'Failed to get comments. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during getCommentsByPublicationId: $e');
      }
      throw Exception('Failed to get comments');
    }
  }

  /// Método para añadir un comentario a una publicación
  /// Future<CommentDTO> indica que el método devolverá un objeto CommentDTO en el futuro
  /// int publicationId y int userId son los IDs de la publicación y el usuario que se enviarán en la URL de la solicitud
  Future<CommentDTO> addComment(
      int publicationId, int userId, CommentDTO commentDTO) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/publication/$publicationId/comments/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'text': commentDTO.text,
        }),
      );

      if (response.statusCode == 200) {
        final addedComment = CommentDTO.fromJson(jsonDecode(response.body));
        return addedComment;
      } else {
        throw Exception(
            'Failed to add comment. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during addComment: $e');
      }
      throw Exception('Failed to add comment');
    }
  }

  /// Método para obtener todos los usuarios
  /// Future<List<UserDTO>> indica que el método devolverá una lista de objetos UserDTO en el futuro
  /// int userId es el ID del usuario que se enviará en la URL de la solicitud
  Future<List<UserDTO>> getAllUsers() async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/user/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));

        List<UserDTO> users = body
            .map(
              (dynamic item) => UserDTO.fromJson(item),
            )
            .toList();
        return users;
      } else {
        throw Exception(
            'Failed to get all users. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during getAllUsers: $e');
      }
      throw Exception('Failed to get all users');
    }
  }

  /// Método para obtener los seguidores de un usuario
  /// Future<List<UserDTO>> indica que el método devolverá una lista de objetos UserDTO en el futuro
  /// int userId es el ID del usuario que se enviará en la URL de la solicitud
  Future<List<UserDTO>> getFollowersByUserId(int userId) async {
    try {
      if (token == null || token!.isEmpty) {
        await loginWithJwt();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/user/$userId/followers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));

        List<UserDTO> followersList = body
            .map(
              (dynamic item) => UserDTO.fromJson(item),
            )
            .toList();
        return followersList;
      } else {
        throw Exception(
            'Failed to get followers list. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during getFollowersByUserId: $e');
      }
      throw Exception('Failed to get followers list');
    }
  }
}
