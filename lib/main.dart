import 'package:flutter/material.dart';
import 'main/splash_screen.dart'; // ganti ini sesuai nama file splash screen kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Sarpras Laravel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Memulai dari splash screen
    );

    
  }
  
}

