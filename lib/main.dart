import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/firebase_options.dart';
import 'package:provider/provider.dart'; 
import 'providers/chat_provider.dart'; 

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