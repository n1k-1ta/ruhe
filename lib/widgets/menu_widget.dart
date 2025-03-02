import 'package:flutter/material.dart';
import 'package:ruhe/screens/profile_screen.dart';
import 'package:ruhe/screens/chat_screen.dart';

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

    _widthAnimation = Tween<double>(begin: 56, end: 220).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 1, curve: Curves.easeIn),
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Center(
            child: Container(
              width: _widthAnimation.value,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD5D0E6),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0D0D0D), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IgnorePointer(
                    ignoring: !_isExpanded, 
                    child: Visibility(
                      visible: _isExpanded, 
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: GestureDetector(
                          onTap: _openProfile,
                          child: const Icon(Icons.account_circle, size: 26, color: Color(0xFF0D0D0D)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: _toggleMenu,
                    child: RotationTransition(
                      turns: _rotationAnimation,
                      child: const Icon(Icons.menu, size: 30, color: Color(0xFF0D0D0D)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  IgnorePointer(
                    ignoring: !_isExpanded, 
                    child: Visibility(
                      visible: _isExpanded, 
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: GestureDetector(
                          onTap: _openChat,
                          child: const Icon(Icons.chat, size: 26, color: Color(0xFF0D0D0D)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
