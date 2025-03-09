import 'package:flutter/material.dart';
import 'package:ruhe/screens/color_screen.dart';
import 'package:ruhe/widgets/menu_widget.dart';
import 'package:ruhe/providers/color_provider.dart'; // Импортируем ValueNotifier

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, "Изменить данные", () {}),
                      const SizedBox(height: 20),
                      _buildButton(context, "Цвет", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ColorScreen(),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      _buildButton(context, "FAQ", () {}),
                      const SizedBox(height: 20),
                      _buildButton(context, "Назад", () {
                        Navigator.pop(context);
                      }),
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

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColorNotifier, // Подписываемся на изменения цвета
      builder: (context, color, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: color, // Используем текущий цвет
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, color: Color(0xFF0D0D0D)),
            ),
          ),
        );
      },
    );
  }
}