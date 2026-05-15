import 'package:flutter/material.dart';
import '../viewmodels/scam_detector_view_model.dart';
import 'example_message_card.dart';

class ExampleMessagesSection extends StatelessWidget {
  final Function(String) onSelect;

  const ExampleMessagesSection({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Try a sample',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ScamDetectorViewModel.exampleMessages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final example = ScamDetectorViewModel.exampleMessages[index];
              return ExampleMessageCard(
                label: example.label,
                onTap: () => onSelect(example.text),
              );
            },
          ),
        ),
      ],
    );
  }
}
