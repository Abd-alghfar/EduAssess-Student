import 'package:flutter/material.dart';

class MatchingWidget extends StatefulWidget {
  final List<String> leftSide;
  final List<String> rightSide;
  final Function(Map<String, String>) onMatchingChanged;
  final Map<String, String>? initialValue;

  const MatchingWidget({
    super.key,
    required this.leftSide,
    required this.rightSide,
    required this.onMatchingChanged,
    this.initialValue,
  });

  @override
  State<MatchingWidget> createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget> {
  late Map<String, String> _matches;

  @override
  void initState() {
    super.initState();
    _matches = widget.initialValue != null
        ? Map<String, String>.from(widget.initialValue!)
        : {};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.leftSide.map((leftItem) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    leftItem,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, color: Colors.grey),
              ),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: _matches[leftItem],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Select Match',
                  ),
                  items: widget.rightSide.map((rightItem) {
                    return DropdownMenuItem(
                      value: rightItem,
                      child: Text(rightItem, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      if (val != null) {
                        _matches[leftItem] = val;
                        widget.onMatchingChanged(_matches);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
