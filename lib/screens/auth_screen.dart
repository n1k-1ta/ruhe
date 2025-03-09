import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'splash_screen.dart';
import '../services/auth_service.dart';
import 'package:ruhe/providers/color_provider.dart'; // Импортируем ValueNotifier

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showSplash = true;
  bool? isLoginScreen;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorMessage;

  // Метод для получения пути к логотипу в зависимости от цвета
  String _getLogoPath(Color color) {
    if (color == const Color(0xFFD5D0E6)) {
      return 'lib/assets/logo_purple.svg';
    } else if (color == const Color(0xFFE1A990)) {
      return 'lib/assets/logo_orange.svg';
    } else if (color == const Color(0xFF8EBEB3)) {
      return 'lib/assets/logo_green.svg';
    } else if (color == const Color(0xFF9DBDE2)) {
      return 'lib/assets/logo_blue.svg';
    } else if (color == const Color(0xFFE0BBC8)) {
      return 'lib/assets/logo_pink.svg';
    } else {
      return 'lib/assets/logo_purple.svg'; // По умолчанию
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFF0D0D0D)),
          if (_showSplash) SplashScreen(onFinish: () => setState(() => _showSplash = false)),
          if (!_showSplash) _buildMainScreen(),
        ],
      ),
    );
  }

  Widget _buildMainScreen() {
    if (isLoginScreen == null) {
      return _buildSelectionScreen();
    } else if (isLoginScreen == true) {
      return _buildAuthScreen(isLogin: true);
    } else {
      return _buildAuthScreen(isLogin: false);
    }
  }

  Widget _buildSelectionScreen() {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColorNotifier,
      builder: (context, color, child) {
        final logoPath = _getLogoPath(color); // 
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(logoPath, width: 100, height: 100), // Используем логотип
              const SizedBox(height: 30),
              _buildButton("Войти", () => setState(() => isLoginScreen = true)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(color: color, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("или", style: TextStyle(color: color)),
                      ),
                      Expanded(
                        child: Divider(color: color, thickness: 1),
                      ),
                    ],
                  ),
                ),
              ),
              _buildButton("Зарегистрироваться", () => setState(() => isLoginScreen = false)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthScreen({required bool isLogin}) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColorNotifier,
      builder: (context, color, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLogin ? "Вход" : "Регистрация",
                style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (!isLogin)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextField(
                    controller: _nameController,
                    decoration: _inputDecoration("Имя", color),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              if (!isLogin)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextField(
                    controller: _birthDateController,
                    decoration: _inputDecoration("Дата рождения", color),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email", color),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration("Пароль", color),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 20),
              _buildButton(isLogin ? "Войти" : "Зарегистрироваться", _submit),
              TextButton(
                onPressed: () => setState(() => isLoginScreen = null),
                child: Text("Назад", style: TextStyle(color: color)),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, Color color) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: color),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColorNotifier,
      builder: (context, color, child) {
        return SizedBox(
          width: 250,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: const Color(0xFF0D0D0D),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(text),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submit() async {
    String? message;
    if (isLoginScreen == true) {
      message = await _authService.signIn(_emailController.text, _passwordController.text);
      if (message == null) {
        Navigator.pushReplacementNamed(context, "/chat");
      } else {
        setState(() => _errorMessage = message);
      }
    } else {
      message = await _authService.signUp(
        _nameController.text,
        _birthDateController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (message == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Подтверждение почты"),
              content: const Text("Пожалуйста, подтвердите вашу почту."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() => isLoginScreen = null);
                  },
                  child: const Text("Хорошо", style: TextStyle(color: Color(0xFF0D0D0D))),
                ),
              ],
            );
          },
        );
      } else {
        setState(() => _errorMessage = message);
      }
    }
  }
}