import 'package:flutter/material.dart';

Widget buildChip(BuildContext context, String label, {IconData? icon}) {
  return Chip(
    backgroundColor: Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    avatar: icon != null ? Icon(icon, size: 18, color: Colors.orange) : null,
    label: Text(label, style: const TextStyle(fontSize: 14)),
  );
}
