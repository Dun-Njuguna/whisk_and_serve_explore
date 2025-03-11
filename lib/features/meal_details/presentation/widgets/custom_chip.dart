import 'package:flutter/material.dart';

Widget buildChip(BuildContext context, String label, {IconData? icon}) {
  return Chip(
    backgroundColor: Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    avatar: icon != null
        ? Icon(icon, size: 20, color: Theme.of(context).colorScheme.onPrimary)
        : null,
    label: Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
    ),
  );
}
