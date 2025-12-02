import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ppt_generator/features/home_screen/data/models/ppt_request_model.dart';
import 'package:ppt_generator/features/home_screen/data/models/ppt_response_model.dart';

class PptService {
  Future<PptResponseModel> generatePpt(PptRequestModel requestBody) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.103:8000/generate-ppt'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to generate presentation');
    }
    final responseModel = PptResponseModel.fromJson(json.decode(response.body));
    if (responseModel.success == false) {
      throw Exception(
        responseModel.message ?? 'Failed to generate presentation',
      );
    }
    return responseModel;
  }
}
