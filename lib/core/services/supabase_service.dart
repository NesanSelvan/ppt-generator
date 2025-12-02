import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  static SupabaseService get instance => _instance;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> verifyOtp(String email, String token) async {
    return await client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
  }

  Future<void> insertUserData({
    required String userId,
    required String email,
  }) async {
    log("current userid. $userId");
    await client.schema('ppt_generator').from('user_data').insert({
      'user_id': userId,
      'email': email,
    });
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<int?> getUserInfoId(String userId) async {
    try {
      final response = await client
          .schema('ppt_generator')
          .from('user_data')
          .select('id')
          .eq('user_id', userId)
          .single();
      return response['id'] as int?;
    } catch (e) {
      log("Error fetching user info id: $e");
      return null;
    }
  }

  Future<void> insertPptGenerationInfo(Map<String, dynamic> data) async {
    try {
      await client
          .schema('ppt_generator')
          .from('ppt_generation_info')
          .insert(data);
      log("PPT generation info inserted successfully");
    } catch (e) {
      log("Error inserting PPT generation info: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getPptHistory(int userInfoId) async {
    try {
      final response = await client
          .schema('ppt_generator')
          .from('ppt_generation_info')
          .select()
          .eq('user_info_id', userInfoId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      log("Error fetching PPT history: $e");
      return [];
    }
  }

  User? get currentUser => client.auth.currentUser;
}
