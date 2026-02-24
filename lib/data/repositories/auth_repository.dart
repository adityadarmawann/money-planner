import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../../core/errors/app_exception.dart';

class AuthRepository {
  final SupabaseClient _client;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required SupabaseClient client,
    required GoogleSignIn googleSignIn,
  })  : _client = client,
        _googleSignIn = googleSignIn;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) return null;
      return _fetchUserProfile(response.user!.id);
    } on AuthException catch (e) {
      throw AuthException(
        message: _mapAuthError(e.message),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw AppException.fromError(e);
    }
  }

  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'username': username},
      );
      if (response.user == null) return null;

      // Update user profile with full name and username
      await Future.delayed(const Duration(seconds: 1));
      await _client.from('users').update({
        'full_name': fullName,
        'username': username,
      }).eq('id', response.user!.id);

      return _fetchUserProfile(response.user!.id);
    } on AuthException catch (e) {
      throw AuthException(
        message: _mapAuthError(e.message),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw AppException.fromError(e);
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.authenticate();
      // ignore: unnecessary_null_comparison
      if (googleAccount == null) return null;

      final idToken = googleAccount.authentication.idToken;
      
      // Request authorization for scopes to get access token
      final clientAuth = await googleAccount.authorizationClient
          .authorizationForScopes(['email', 'profile']);
      final accessToken = clientAuth?.accessToken;

      if (accessToken == null || idToken == null) {
        throw const AuthException(message: 'Gagal mendapatkan token Google');
      }

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) return null;
      return _fetchUserProfile(response.user!.id);
    } on AuthException catch (e) {
      throw AuthException(
        message: _mapAuthError(e.message),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _client.auth.signOut();
    } catch (e) {
      throw AppException.fromError(e);
    }
  }

  Future<UserModel?> _fetchUserProfile(String userId) async {
    try {
      final data = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (data == null) return null;
      return UserModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  String _mapAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid credentials')) {
      return 'Email atau kata sandi salah';
    } else if (lower.contains('email already registered') ||
        lower.contains('user already registered')) {
      return 'Email sudah terdaftar';
    } else if (lower.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi. Cek inbox kamu';
    } else if (lower.contains('too many requests')) {
      return 'Terlalu banyak percobaan. Coba lagi nanti';
    }
    return message;
  }
}
