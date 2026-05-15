import 'package:flutter/material.dart';
import '../viewmodels/scam_detector_view_model.dart';
import 'example_message_card.dart';

class ExampleList extends StatelessWidget {
  final Function(String) onSelect;

  const ExampleList({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Try an example',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Using Wrap instead of GridView for better responsiveness across devices
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ScamDetectorViewModel.exampleMessages.map((example) {
              return SizedBox(
                // On mobile, show 2 per row. On desktop, show more.
                width: (MediaQuery.of(context).size.width > 600) 
                  ? 240 
                  : (MediaQuery.of(context).size.width - 52) / 2,
                child: ExampleMessageCard(
                  label: example.label,
                  onTap: () => onSelect(example.text),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
