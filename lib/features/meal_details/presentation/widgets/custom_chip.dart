import 'package:flutter/material.dart';

Widget buildChip(String label, {IconData? icon}) {
  return Chip(
    backgroundColor: Colors.orange.shade100,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    avatar: icon != null ? Icon(icon, size: 18, color: Colors.orange) : null,
    label: Text(label, style: const TextStyle(fontSize: 14)),
  );
}
