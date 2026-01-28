import 'package:flutter/material.dart';

class TrueFalseWidget extends StatelessWidget {
  final Function(bool) onSelected;
  final bool? initialValue;

  const TrueFalseWidget({
    super.key,
    required this.onSelected,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSelected(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: initialValue == true
                  ? Colors.green
                  : Colors.grey.shade200,
              foregroundColor: initialValue == true
                  ? Colors.white
                  : Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'True',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSelected(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: initialValue == false
                  ? Colors.red
                  : Colors.grey.shade200,
              foregroundColor: initialValue == false
                  ? Colors.white
                  : Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'False',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
