class AdaptiveWeight {
  final String featureKey;
  final int adjustment;

  const AdaptiveWeight({
    required this.featureKey,
    required this.adjustment,
  });

  Map<String, dynamic> toJson() => {
    'featureKey': featureKey,
    'adjustment': adjustment,
  };

  factory AdaptiveWeight.fromJson(Map<String, dynamic> json) => AdaptiveWeight(
    featureKey: json['featureKey'],
    adjustment: json['adjustment'],
  );
}
