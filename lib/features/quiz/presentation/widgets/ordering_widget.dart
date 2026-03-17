import 'package:flutter/material.dart';

class OrderingWidget extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onOrderChanged;
  final List<String>? initialValue;

  const OrderingWidget({
    super.key,
    required this.items,
    required this.onOrderChanged,
    this.initialValue,
  });

  @override
  State<OrderingWidget> createState() => _OrderingWidgetState();
}

class _OrderingWidgetState extends State<OrderingWidget> {
  late List<String> _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder =
        widget.initialValue != null
              ? List<String>.from(widget.initialValue!)
              : List<String>.from(widget.items)
          ..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Drag to reorder items in the correct sequence:',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = _currentOrder.removeAt(oldIndex);
              _currentOrder.insert(newIndex, item);
              widget.onOrderChanged(_currentOrder);
            });
          },
          children: List.generate(_currentOrder.length, (index) {
            final item = _currentOrder[index];
            return Card(
              key: ValueKey(item),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.drag_handle),
                title: Text(item),
                trailing: CircleAvatar(
                  radius: 12,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
