import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../../core/errors/app_exception.dart';

class UserRepository {
  final SupabaseClient _client;

  UserRepository({required SupabaseClient client}) : _client = client;

  Future<UserModel?> getUserById(String userId) async {
    try {
      final data = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (data == null) return null;
      return UserModel.fromJson(data);
    } catch (e) {
      throw AppException.fromError(e);
    }
  }

  Future<UserModel?> getUserByUsername(String username) async {
    try {
      final data = await _client
          .from('users')
          .select()
          .eq('username', username)
          .maybeSingle();
      if (data == null) return null;
      return UserModel.fromJson(data);
    } catch (e) {
      throw AppException.fromError(e);
    }
  }

  Future<UserModel> updateProfile({
    required String userId,
    String? fullName,
    String? username,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (username != null) updates['username'] = username;
      if (phone != null) updates['phone'] = phone;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final data = await _client
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();
      return UserModel.fromJson(data);
    } catch (e) {
      throw AppException.fromError(e);
    }
  }

  Future<String?> uploadAvatar({
    required String userId,
    required List<int> bytes,
    required String fileName,
  }) async {
    try {
      final path = 'avatars/$userId/$fileName';
      await _client.storage.from('avatars').uploadBinary(
            path,
            Uint8List.fromList(bytes),
            fileOptions: const FileOptions(upsert: true),
          );
      final url = _client.storage.from('avatars').getPublicUrl(path);
      return url;
    } catch (e) {
      throw AppException.fromError(e);
    }
  }
}
