import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/wallet_model.dart';
import '../../core/errors/app_exception.dart';

class WalletRepository {
  final SupabaseClient _client;

  WalletRepository({required SupabaseClient client}) : _client = client;

  Future<WalletModel?> getWallet(String userId) async {
    try {
      final data = await _client
          .from('wallets')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (data == null) return null;
      return WalletModel.fromJson(data);
    } catch (e) {
      throw AppException.fromError(e);
    }
  }

  Future<WalletModel> topUp({
    required String userId,
    required double amount,
  }) async {
    try {
      final wallet = await getWallet(userId);
      if (wallet == null) throw const AppException(message: 'Wallet tidak ditemukan');

      final newBalance = wallet.balance + amount;
      final data = await _client
          .from('wallets')
          .update({'balance': newBalance})
          .eq('user_id', userId)
          .select()
          .single();
      return WalletModel.fromJson(data);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromError(e);
    }
  }

  Future<WalletModel> deductBalance({
    required String userId,
    required double amount,
  }) async {
    try {
      final wallet = await getWallet(userId);
      if (wallet == null) throw const AppException(message: 'Wallet tidak ditemukan');
      if (wallet.balance < amount) throw const InsufficientBalanceException();

      final newBalance = wallet.balance - amount;
      final data = await _client
          .from('wallets')
          .update({'balance': newBalance})
          .eq('user_id', userId)
          .select()
          .single();
      return WalletModel.fromJson(data);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromError(e);
    }
  }

  Future<WalletModel> addBalance({
    required String userId,
    required double amount,
  }) async {
    try {
      final wallet = await getWallet(userId);
      if (wallet == null) throw const AppException(message: 'Wallet tidak ditemukan');

      final newBalance = wallet.balance + amount;
      final data = await _client
          .from('wallets')
          .update({'balance': newBalance})
          .eq('user_id', userId)
          .select()
          .single();
      return WalletModel.fromJson(data);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromError(e);
    }
  }
}
