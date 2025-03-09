import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruhe/widgets/menu_widget.dart';
import 'package:ruhe/providers/color_provider.dart'; // Импортируем ValueNotifier

class ColorScreen extends StatefulWidget {
  const ColorScreen({super.key});

  @override
  _ColorScreenState createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  Color selectedColor = selectedColorNotifier.value; // Используем значение из ValueNotifier

  final List<Color> colors = [
    const Color(0xFFD5D0E6),
    const Color(0xFFE1A990),
    const Color(0xFF8EBEB3),
    const Color(0xFF9DBDE2),
    const Color(0xFFE0BBC8),
  ];

  @override
  void initState() {
    super.initState();
    _loadColorFromFirebase(); // Загружаем цвет из Firebase при инициализации
  }

  // Метод для загрузки цвета из Firebase
  Future<void> _loadColorFromFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && mounted) {
        Map<String, dynamic> colorData = doc['selectedColor'];
        setState(() {
          selectedColor = Color.fromARGB(
            colorData['a'],
            colorData['r'],
            colorData['g'],
            colorData['b'],
          );
          selectedColorNotifier.value = selectedColor; // Обновляем ValueNotifier
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < colors.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: _buildColorButton(colors[i], i),
                        ),
                      const SizedBox(height: 20),
                      _buildDoneButton(context),
                    ],
                  ),
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
  }

  Widget _buildColorButton(Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
        child: selectedColor == color
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 30,
              )
            : null,
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextButton(
        onPressed: () {
          _saveColorToFirebase(selectedColor);
          Navigator.pop(context); // Переход на экран настроек
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: selectedColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text(
          "Готово",
          style: TextStyle(fontSize: 18, color: Color(0xFF0D0D0D)),
        ),
      ),
    );
  }

  // Метод для сохранения цвета в Firebase
  void _saveColorToFirebase(Color color) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'selectedColor': {
          'r': color.red,
          'g': color.green,
          'b': color.blue,
          'a': color.alpha,
        }
      });
      if (mounted) {
        setState(() {
          selectedColorNotifier.value = color; // Обновляем ValueNotifier
        });
      }
    }
  }
}