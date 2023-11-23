import 'dart:convert';
import 'package:battleships/views/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/sessionmanager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _login(context),
                  child: const Text('Log in'),
                ),
                TextButton(
                  onPressed: () => _register(context),
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    final url = Uri.parse('http://165.227.117.48/login');
    final response = await http.post(url, 
      headers: {
        'Content-Type': 'application/json', 
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      })
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final sessionToken = response.body.split("\"")[3];
      // print(sessionToken);
      await SessionManager.setSessionToken(sessionToken);
      await SessionManager.setSessionUserName(username);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }

  Future<void> _register(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    final url = Uri.parse('http://165.227.117.48/register');
    final response = await http.post(url, 
      headers: {
        'Content-Type': 'application/json', 
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      })
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final sessionToken = response.body.split("\"")[3];

      await SessionManager.setSessionToken(sessionToken);
      await SessionManager.setSessionUserName(username);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed')),
      );
    }
  }
}
