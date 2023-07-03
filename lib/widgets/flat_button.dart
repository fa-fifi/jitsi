import 'package:flutter/material.dart';

class FlatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const FlatButton({super.key, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1)),
      child: Text(label));
}
