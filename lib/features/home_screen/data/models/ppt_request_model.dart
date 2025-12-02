class PptRequestModel {
  final String topic;
  final String extraInfoSource;
  final String email;
  final String accessId;
  final String presentationFor;
  final int slideCount;
  final String language;
  final String template;
  final String model;
  final bool aiImages;
  final bool imageForEachSlide;
  final bool googleImage;
  final bool googleText;
  final Map<String, dynamic>? watermark;

  PptRequestModel({
    required this.topic,
    required this.extraInfoSource,
    required this.email,
    required this.accessId,
    required this.presentationFor,
    required this.slideCount,
    required this.language,
    required this.template,
    required this.model,
    required this.aiImages,
    required this.imageForEachSlide,
    required this.googleImage,
    required this.googleText,
    this.watermark,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'extraInfoSource': extraInfoSource,
      'email': email,
      'accessId': accessId,
      'presentationFor': presentationFor,
      'slideCount': slideCount,
      'language': language,
      'template': template,
      'model': model,
      'aiImages': aiImages,
      'imageForEachSlide': imageForEachSlide,
      'googleImage': googleImage,
      'googleText': googleText,
      if (watermark != null) 'watermark': watermark,
    };
  }
}
