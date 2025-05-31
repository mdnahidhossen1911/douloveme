import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const LoveApp());

class LoveApp extends StatelessWidget {
  const LoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LovePage(),
    );
  }
}

class LovePage extends StatefulWidget {
  const LovePage({super.key});

  @override
  State<LovePage> createState() => _LovePageState();
}

class _LovePageState extends State<LovePage> with TickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  final double _buttonWidth = 150;
  final double _buttonHeight = 55;
  double _noX = 0;
  double _noY = 0;
  bool _showHeart = false;
  bool _initPositionSet = false;
  bool _noVisible = true;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heartScale = Tween<double>(begin: 0, end: 1.2).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
  }

  void _moveNoButton(BoxConstraints constraints) {
    final random = Random();
    setState(() {
      _noX = random.nextDouble() * (constraints.maxWidth - _buttonWidth);
      _noY = random.nextDouble() * (constraints.maxHeight - _buttonHeight);
    });
  }

  void _checkMousePosition(PointerHoverEvent event, BoxConstraints constraints) {
    if (!_noVisible) return;

    final mouseX = event.position.dx;
    final mouseY = event.position.dy;
    final noCenterX = _noX + _buttonWidth / 2;
    final noCenterY = _noY + _buttonHeight / 2;

    // 🔥 বড় hover range = 120 px
    final distance = sqrt(pow(mouseX - noCenterX, 2) + pow(mouseY - noCenterY, 2));

    if (distance < 120) {
      _moveNoButton(constraints);
    }
  }

  void _onLovePressed() {
    setState(() {
      _showHeart = true;
      _noVisible = false;
    });
    _heartController.forward(from: 0);
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (!_initPositionSet) {
        _noX = constraints.maxWidth / 2 - _buttonWidth / 2;
        _noY = constraints.maxHeight / 2 + _buttonHeight + 20;
        _initPositionSet = true;
      }

      return Scaffold(
        body: Listener(
          onPointerHover: (e) => _checkMousePosition(e, constraints),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "🌸 Do you love me? 🌸",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 6, color: Colors.black38)],
                        ),
                      ),
                      const SizedBox(height: 35),
                      ElevatedButton(
                        onPressed: _onLovePressed,
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(_buttonWidth, _buttonHeight),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10,
                        ),
                        child: const Text(
                          "❤️ I love you",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 35),
                      if (_showHeart)
                        ScaleTransition(
                          scale: _heartScale,
                          child: const Icon(
                            Icons.favorite,
                            size: 120,
                            color: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                ),
                if (_noVisible)
                  Positioned(
                    left: _noX,
                    top: _noY,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(_buttonWidth, _buttonHeight),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                      ),
                      child: const Text("No 😢", style: TextStyle(fontSize: 16)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
