import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart'; // Добавляем пакет для Provider
import 'chat_provider.dart'; // Импортируем ChatProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Sansation', // 
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => AuthScreen(),
          "/chat": (context) => ChatScreen(),
        },
      ),
    );
  }
}