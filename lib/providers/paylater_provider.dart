import 'package:flutter/foundation.dart';
import '../data/models/paylater_account_model.dart';
import '../data/models/paylater_bill_model.dart';
import '../data/repositories/paylater_repository.dart';
import '../core/errors/app_exception.dart';

class PaylaterProvider extends ChangeNotifier {
  final PaylaterRepository _paylaterRepository;

  PaylaterAccountModel? _account;
  List<PaylaterBillModel> _bills = [];
  bool _isLoading = false;
  String? _errorMessage;

  PaylaterProvider({required PaylaterRepository paylaterRepository})
      : _paylaterRepository = paylaterRepository;

  PaylaterAccountModel? get account => _account;
  List<PaylaterBillModel> get bills => _bills;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<PaylaterBillModel> get activeBills =>
      _bills.where((b) => b.status == BillStatus.active).toList();

  List<PaylaterBillModel> get paidBills =>
      _bills.where((b) => b.status == BillStatus.paid).toList();

  Future<void> loadAccount(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _account = await _paylaterRepository.getAccount(userId);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBills(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bills = await _paylaterRepository.getBills(userId);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> disbursePaylater({
    required String userId,
    required String walletId,
    required double amount,
    required int tenorMonths,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _paylaterRepository.disbursePaylater(
        userId: userId,
        walletId: walletId,
        amount: amount,
        tenorMonths: tenorMonths,
      );
      final bill = result['bill'] as PaylaterBillModel;
      _bills.insert(0, bill);

      // Refresh account
      _account = await _paylaterRepository.getAccount(userId);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> payBill({
    required String billId,
    required String userId,
    required String walletId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedBill = await _paylaterRepository.payBill(
        billId: billId,
        userId: userId,
        walletId: walletId,
      );
      final idx = _bills.indexWhere((b) => b.id == billId);
      if (idx != -1) _bills[idx] = updatedBill;

      // Refresh account
      _account = await _paylaterRepository.getAccount(userId);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
