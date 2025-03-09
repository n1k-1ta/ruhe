import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruhe/screens/auth_screen.dart';
import 'package:ruhe/screens/settings_screen.dart';
import 'package:ruhe/widgets/menu_widget.dart';
import 'package:ruhe/providers/color_provider.dart'; // Импортируем ValueNotifier

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Загрузка...";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = userDoc['name'] ?? 'Без имени';
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
    }
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColorNotifier,
      builder: (context, color, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 200),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              userName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: color.computeLuminance() > 0.5
                                    ? Colors.black
                                    : const Color.fromARGB(255, 0, 0, 0), // Авто-контраст цвета текста
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: _buildButton("Настройки", _goToSettings),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: _buildButton("Выйти", _logout),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: MenuWidget(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColorNotifier,
      builder: (context, color, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color, width: 2), // Глобальный цвет границы
          ),
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: color, // Глобальный цвет кнопки
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: color.computeLuminance() > 0.5
                    ? Colors.black
                    : const Color.fromARGB(255, 0, 0, 0), // Контрастный цвет текста
              ),
            ),
          ),
        );
      },
    );
  }
}
