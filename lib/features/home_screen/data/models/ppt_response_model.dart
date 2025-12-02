class PptResponseModel {
  final bool success;
  final PptData? data;
  final String? message;

  PptResponseModel({required this.success, this.data, this.message});

  factory PptResponseModel.fromJson(Map<String, dynamic> json) {
    return PptResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? PptData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class PptData {
  final String url;

  PptData({required this.url});

  factory PptData.fromJson(Map<String, dynamic> json) {
    return PptData(url: json['url'] ?? '');
  }
}
