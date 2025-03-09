import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ruhe/providers/color_provider.dart'; // Импортируем ValueNotifier

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.forward().then((_) => widget.onFinish());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColorNotifier,
      builder: (context, color, child) {
        return SlideTransition(
          position: _animation,
          child: Container(
            color: color,
            child: Center(
              child: SvgPicture.asset('lib/assets/logo_ruhe.svg', width: 50, height: 50),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}