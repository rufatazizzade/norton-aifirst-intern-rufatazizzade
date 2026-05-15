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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 56,
            ),
            itemCount: ScamDetectorViewModel.exampleMessages.length,
            itemBuilder: (context, index) {
              final example = ScamDetectorViewModel.exampleMessages[index];
              return ExampleMessageCard(
                label: example.label,
                onTap: () => onSelect(example.text),
              );
            },
          ),
        ],
      ),
    );
  }
}
