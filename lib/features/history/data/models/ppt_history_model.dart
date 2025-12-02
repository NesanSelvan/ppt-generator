class PptHistoryModel {
  final int id;
  final String topic;
  final DateTime createdAt;
  final String? resultUrl;
  final bool resultSuccess;
  final int slideCount;
  final String? template;

  PptHistoryModel({
    required this.id,
    required this.topic,
    required this.createdAt,
    this.resultUrl,
    required this.resultSuccess,
    required this.slideCount,
    this.template,
  });

  factory PptHistoryModel.fromJson(Map<String, dynamic> json) {
    return PptHistoryModel(
      id: json['id'] as int,
      topic: json['topic'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      resultUrl: json['result_url'] as String?,
      resultSuccess: json['result_success'] as bool,
      slideCount: json['slide_count'] as int? ?? 10,
      template: json['template'] as String?,
    );
  }
}
