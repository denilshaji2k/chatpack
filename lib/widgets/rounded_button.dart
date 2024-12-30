import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final Function onPressed;
  final double height;
  final double width;

  const RoundedButton({
    super.key,
    required this.name,
    required this.onPressed,
    required this.height,
    required this.width,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
    decoration:BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(15),
    ),
      width: width,
      
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}