import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Column(
      children: [
        _buildOption(
          context,
          label: 'True',
          value: true,
          icon: FontAwesomeIcons.check,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildOption(
          context,
          label: 'False',
          value: false,
          icon: FontAwesomeIcons.xmark,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String label,
    required bool value,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = initialValue == value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
          width: isSelected ? 2.5 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSelected(value),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? color : Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(width: 20),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    color: isSelected ? color : const Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    FontAwesomeIcons.solidCircleCheck,
                    color: color,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
