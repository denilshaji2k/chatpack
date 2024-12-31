import 'dart:io';

import 'package:flutter/material.dart';

class RoundedImageNetwork extends StatelessWidget {
  final String imagePath;
  final double size;
  
  const RoundedImageNetwork({
    super.key,
    required this.imagePath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(size),
        ),
        color: Colors.black,
      ),
    );
  } 
}

class RoundedImageNetworkWithStatusIndicator extends RoundedImageNetwork{
  final bool isActive;

  RoundedImageNetworkWithStatusIndicator({
    required Key key,
    required String imagePath,
    required double size,
    required this.isActive,
  }) : super(imagePath: imagePath, size: size);

  @override
  Widget build(BuildContext context) {
    return Stack(
clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        super.build(context),
        Container(
          height: size * 0.2,
          width: size * 0.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.red,
            border: Border.all(
              color: Colors.white,
              width: size * 0.01,
            ),
          ),
        )
        
      ],
    );

  }
}

class RoundedImageFile extends StatelessWidget {
  final File image;
  final double size;

  const RoundedImageFile({
    required this.image,
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.file(
        image,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

