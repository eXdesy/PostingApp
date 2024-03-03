import 'package:flutter/material.dart';
import 'package:posting_app/controllers/ApiService.dart';
import 'package:posting_app/controllers/UserDTO.dart';
import 'package:posting_app/main.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

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
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 0),
                Text(
                  'Posting...',
                  style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 100),
                TextField(
                  controller: usernameController,
                  style: TextStyle(color: Color.fromARGB(255, 119, 0, 255)),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: Color.fromARGB(255, 119, 0, 255)),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                  obscureText: true,
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
                      child: Text('Login'),
                      onPressed: () async {
                        try {
                          await ApiService().loginWithJwt();
                          UserDTO user = await ApiService().loginUser(
                            usernameController.text,
                            passwordController.text,
                          );
                          MyApp.loggedInUser = user;
                          Navigator.pushReplacementNamed(context, '/home');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to login')),
                          );
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
                      child: Text('Register'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
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
