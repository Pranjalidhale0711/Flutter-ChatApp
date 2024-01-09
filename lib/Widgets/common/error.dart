import 'package:flutter/material.dart';

class Errorscreen extends StatelessWidget {
  const Errorscreen({required this.error, super.key});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
