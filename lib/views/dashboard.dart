import 'package:battleships/views/homescreen.dart';
import 'package:battleships/views/loginscreen.dart';
import 'package:flutter/material.dart';
import '../utils/sessionmanager.dart';
import 'package:http/http.dart' as http;


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await SessionManager.isLoggedIn();
    final response = await http.get(Uri.parse('http://165.227.117.48/games'),headers: {'Authorization' : 'Bearer ${await SessionManager.getSessionToken()}'});
    if (mounted) {
      setState(() {
        isLoggedIn = response.statusCode==200 ? loggedIn : false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battelships',
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}




