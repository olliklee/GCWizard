import 'package:flutter/material.dart';

class GCWGrid extends StatelessWidget {
  final List<Widget> items;
  final String? title;

  const GCWGrid({
    super.key,
    required this.items, this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 120, // Maximale Breite der Elemente
      crossAxisSpacing: 10, // Abstand zwischen Spalten
      mainAxisSpacing: 10, // Abstand zwischen Zeilen
      padding: const EdgeInsets.all(10), // Innenabstand des Grids
      children: items.map((item) {
        return Container(
          color: Colors.green,
          child: Center(
            child:
              item,
            ),
          );
      }).toList(), // Konvertiere die Liste in eine Widget-Liste
    );
  }
}