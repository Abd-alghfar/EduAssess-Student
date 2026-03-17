import 'package:flutter/material.dart';

class MultiSelectWidget extends StatefulWidget {
  final List<String> options;
  final Function(List<String>) onSelected;
  final List<String>? initialValue;

  const MultiSelectWidget({
    super.key,
    required this.options,
    required this.onSelected,
    this.initialValue,
  });

  @override
  State<MultiSelectWidget> createState() => _MultiSelectWidgetState();
}

class _MultiSelectWidgetState extends State<MultiSelectWidget> {
  late List<String> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = widget.initialValue != null
        ? List<String>.from(widget.initialValue!)
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        final isSelected = _selectedOptions.contains(option);
        return Card(
          elevation: isSelected ? 4 : 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: CheckboxListTile(
            title: Text(option),
            value: isSelected,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedOptions.add(option);
                } else {
                  _selectedOptions.remove(option);
                }
                widget.onSelected(_selectedOptions);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }).toList(),
    );
  }
}
