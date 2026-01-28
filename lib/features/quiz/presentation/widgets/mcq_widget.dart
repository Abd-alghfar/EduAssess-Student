import 'package:flutter/material.dart';

class MCQWidget extends StatelessWidget {
  final List<String> options;
  final Function(String) onSelected;
  final String? initialValue;

  const MCQWidget({
    super.key,
    required this.options,
    required this.onSelected,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final isSelected = initialValue == option;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: isSelected ? Colors.blue.shade100 : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? const BorderSide(color: Colors.blue, width: 2)
                : BorderSide.none,
          ),
          child: ListTile(
            title: Text(
              option,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : null,
            onTap: () => onSelected(option),
          ),
        );
      }).toList(),
    );
  }
}
