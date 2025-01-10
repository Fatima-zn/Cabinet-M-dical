import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const Tile({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      onTap: onTap,
    );
  }
}
