import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class Home extends StatefulWidget {
  final String value;
  final VoidCallback onPressed;

  const Home({super.key,
    required this.value,
    required this.onPressed
  });
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child:  GlassContainer.frostedGlass(
        height: 200,
        width: 350,
        borderRadius: BorderRadius.circular(25.0),
        borderWidth: 1.5,
        blur: 15.0,
        frostedOpacity: 0.06,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.40),
            Colors.white.withOpacity(0.06),
          ],
          begin: const Alignment(-0.10, -1.0),
          end: const Alignment(0.00, 1.0),
        ),
        borderGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.70),
              Colors.white.withOpacity(0.0),
              Colors.grey.withOpacity(0.0),
              Colors.grey.withOpacity(0.60),
            ],
            begin: const Alignment(0.35, -1.0),
            end: Alignment.bottomRight,
            stops: const [0.0, 0.30, 0.31, 1.0]
          // stops: []
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
        elevation: 5.0,
        child: Text(widget.value),
      ),
    );
  }
}
