import 'scam_category.dart';

/// A single scam indicator detected during analysis.
///
/// Each signal has a human-readable [title] and [description],
/// plus a numeric [weight] that contributes to the overall confidence score.
class ScamSignal {
  final String title;
  final String description;
  final int weight;
  final ScamCategory category;

  const ScamSignal({
    required this.title,
    required this.description,
    required this.weight,
    this.category = ScamCategory.unknown,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScamSignal &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          weight == other.weight;

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ weight.hashCode;

  @override
  String toString() => 'ScamSignal(title: $title, weight: $weight)';
}
