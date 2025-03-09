import 'package:flutter/material.dart';
import 'package:ruhe/screens/profile_screen.dart';
import 'package:ruhe/screens/chat_screen.dart';
import 'package:ruhe/providers/color_provider.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _widthAnimation = Tween<double>(begin: 45, end: 180).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1, curve: Curves.easeIn),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: Center(
        child: ValueListenableBuilder<Color>(
          valueListenable: selectedColorNotifier,
          builder: (context, color, child) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: _widthAnimation.value,
                  height: 45,
                  decoration: BoxDecoration(
                    color: color, // Теперь цвет меняется мгновенно
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF0D0D0D), width: 2),
                  ),
                  child: ClipRect(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isExpanded)
                          Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: GestureDetector(
                                onTap: _openProfile,
                                child: const Icon(Icons.account_circle, size: 26, color: Color(0xFF0D0D0D)),
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: _toggleMenu,
                          child: RotationTransition(
                            turns: _rotationAnimation,
                            child: const Icon(Icons.menu, size: 30, color: Color(0xFF0D0D0D)),
                          ),
                        ),
                        if (_isExpanded)
                          Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: GestureDetector(
                                onTap: _openChat,
                                child: const Icon(Icons.chat, size: 26, color: Color(0xFF0D0D0D)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
