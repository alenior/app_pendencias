import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_pendencias/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final user = await _authService.signInWithGoogle();
              if (user != null) {
                print('Usuário logado: ${user.displayName}');
              } else {
                print('Falha no login');
              }
            },
            child: Text('Login com Google'),
          ),
        ),
      ),
    );
  }
}
