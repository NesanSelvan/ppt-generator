import 'package:equatable/equatable.dart';

abstract class PptGeneratorEvent extends Equatable {
  const PptGeneratorEvent();

  @override
  List<Object> get props => [];
}

class GeneratePptRequested extends PptGeneratorEvent {
  final String topic;
  final String audience;
  final int slideCount;
  final String language;
  final String templateStyle;
  final String model;
  final bool aiImages;
  final bool imageOnEachSlide;
  final bool googleImages;
  final bool googleText;
  final String extraInfoSource;
  final String email;
  final String accessId;
  final Map<String, dynamic>? watermark;

  const GeneratePptRequested({
    required this.topic,
    required this.audience,
    required this.slideCount,
    required this.language,
    required this.templateStyle,
    required this.model,
    required this.aiImages,
    required this.imageOnEachSlide,
    required this.googleImages,
    required this.googleText,
    required this.extraInfoSource,
    required this.email,
    required this.accessId,
    this.watermark,
  });

  @override
  List<Object> get props => [
    topic,
    audience,
    slideCount,
    language,
    templateStyle,
    model,
    aiImages,
    imageOnEachSlide,
    googleImages,
    googleText,
    extraInfoSource,
    email,
    accessId,
    if (watermark != null) watermark!,
  ];
}
