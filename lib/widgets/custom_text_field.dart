import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final int? maxLength;

  const CustomTextField(
      {super.key,
      required this.labelText,
      this.hintText,
      required this.controller,
      this.maxLength});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(5), child: Text(labelText)),
          TextField(
            controller: controller,
            maxLength: maxLength,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: hintText,
              isDense: true,
              filled: true,
              counterStyle: Theme.of(context).textTheme.labelSmall,
              fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(5)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          if (maxLength == null) const SizedBox(height: 10),
        ],
      );
}
