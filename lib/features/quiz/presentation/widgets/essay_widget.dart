import 'package:flutter/material.dart';

class EssayWidget extends StatefulWidget {
  final Function(String) onSubmit;
  final String? initialValue;

  const EssayWidget({super.key, required this.onSubmit, this.initialValue});

  @override
  State<EssayWidget> createState() => _EssayWidgetState();
}

class _EssayWidgetState extends State<EssayWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAnswered = widget.initialValue != null;

    return Column(
      children: [
        TextField(
          controller: _controller,
          maxLines: 5,
          enabled: !isAnswered,
          decoration: InputDecoration(
            hintText: 'Type your answer here...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isAnswered ? Colors.grey.shade100 : Colors.white,
          ),
        ),
        if (!isAnswered) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.onSubmit(_controller.text),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Submit Answer'),
          ),
        ],
      ],
    );
  }
}
