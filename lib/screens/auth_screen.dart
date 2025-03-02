import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'splash_screen.dart';
import '../services/auth_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Color(0xFF0D0D0D)),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('lib/assets/logo_purple.svg', width: 100, height: 100),
          SizedBox(height: 30),
          _buildButton("Войти", () => setState(() => isLoginScreen = true)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: SizedBox(
              width: 250, 
              child: Row(
                children: [
                  Expanded(
                    child: Divider(color: Color(0xFFD5D0E6), thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("или", style: TextStyle(color: Color(0xFFD5D0E6))),
                  ),
                  Expanded(
                    child: Divider(color: Color(0xFFD5D0E6), thickness: 1),
                  ),
                ],
              ),
            ),
          ),
          _buildButton("Зарегистрироваться", () => setState(() => isLoginScreen = false)),
        ],
      ),
    );
  }

  Widget _buildAuthScreen({required bool isLogin}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLogin ? "Вход" : "Регистрация",
            style: TextStyle(color: Color(0xFFD5D0E6), fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          if (!isLogin)
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: TextField(
                controller: _nameController,
                decoration: _inputDecoration("Имя"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (!isLogin)
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: TextField(
                controller: _birthDateController,
                decoration: _inputDecoration("Дата рождения"),
                readOnly: true,
                onTap: () => _selectDate(context),
                style: TextStyle(color: Colors.white),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: TextField(
              controller: _emailController,
              decoration: _inputDecoration("Email"),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: _inputDecoration("Пароль"),
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ),
          SizedBox(height: 20),
          _buildButton(isLogin ? "Войти" : "Зарегистрироваться", _submit),
          TextButton(
            onPressed: () => setState(() => isLoginScreen = null),
            child: Text("Назад", style: TextStyle(color: Color(0xFFD5D0E6))),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFFD5D0E6)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D0E6))),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 250, 
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD5D0E6),
          foregroundColor: Color(0xFF0D0D0D),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(text),
      ),
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
              title: Text("Подтверждение почты"),
              content: Text("Пожалуйста, подтвердите вашу почту."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() => isLoginScreen = null);
                  },
                  child: Text("Хорошо", style: TextStyle(color: Color.fromARGB(0, 13, 13, 13))),
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