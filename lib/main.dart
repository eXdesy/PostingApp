import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:posting_app/pages/EditProfilePage.dart';
import 'package:posting_app/pages/HomePage.dart';
import 'package:posting_app/pages/LoginPage.dart';
import 'package:posting_app/pages/RegisterPage.dart';
import 'package:posting_app/pages/SearchPage.dart';
import 'controllers/UserDTO.dart';
import 'pages/ProfilePage.dart';
import 'pages/PublicationDetailsPage.dart';

/// Clase principal de la aplicación
void main() {
  utf8.decoder;
  runApp(const MyApp());
}

/// Clase que representa la aplicación
class MyApp extends StatelessWidget {
  static UserDTO? loggedInUser;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posting...',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/publicationDetails': (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final int publicationId = args['publicationId'];
          return PublicationDetailsPage(publicationId: publicationId);
        },
        '/edit-profile' :(context) => EditProfilePage(user: MyApp.loggedInUser!),
        '/search': (context) => const SearchPage(),
      },
    );
  }
}