import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_plan_model.dart';

class ExpensePlanRepository {
  final SupabaseClient _client;

  ExpensePlanRepository({required SupabaseClient client}) : _client = client;

  // Get all expense plans untuk user
  Future<List<ExpensePlan>> getAllExpensePlans(String userId) async {
    try {
      final response = await _client
          .from('expense_plans')
          .select()
          .eq('user_id', userId)
          .order('planned_date', ascending: false);

      return (response as List)
          .map((item) => ExpensePlan.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch expense plans: $e');
    }
  }

  // Get expense plans untuk bulan tertentu
  Future<List<ExpensePlan>> getExpensePlansByMonth(
    String userId,
    int year,
    int month,
  ) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      final response = await _client
          .from('expense_plans')
          .select()
          .eq('user_id', userId)
          .gte('planned_date', startDate.toIso8601String().split('T')[0])
          .lte('planned_date', endDate.toIso8601String().split('T')[0])
          .order('planned_date', ascending: true);

      return (response as List)
          .map((item) => ExpensePlan.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch expense plans for month: $e');
    }
  }

  // Get expense plans untuk tanggal spesifik
  Future<List<ExpensePlan>> getExpensePlansByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await _client
          .from('expense_plans')
          .select()
          .eq('user_id', userId)
          .eq('planned_date', dateStr)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => ExpensePlan.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch expense plans for date: $e');
    }
  }

  // Create expense plan
  Future<ExpensePlan> createExpensePlan({
    required String userId,
    required String title,
    required double amount,
    required DateTime plannedDate,
    required String category,
    required String paymentSource,
    String? reminderType,
    int? customReminderHours,
    String? notes,
  }) async {
    try {
      final response = await _client
          .from('expense_plans')
          .insert({
            'user_id': userId,
            'title': title,
            'amount': amount,
            'planned_date': plannedDate.toIso8601String().split('T')[0],
            'category': category,
            'payment_source': paymentSource,
            'reminder_type': reminderType,
            'custom_reminder_hours': customReminderHours,
            'notes': notes,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return ExpensePlan.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create expense plan: $e');
    }
  }

  // Update expense plan
  Future<ExpensePlan> updateExpensePlan(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _client
          .from('expense_plans')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return ExpensePlan.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update expense plan: $e');
    }
  }

  // Delete expense plan
  Future<void> deleteExpensePlan(String id) async {
    try {
      await _client.from('expense_plans').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete expense plan: $e');
    }
  }

  // Mark as completed
  Future<ExpensePlan> markAsCompleted(String id) async {
    try {
      final response = await _client
          .from('expense_plans')
          .update({
            'is_completed': true,
            'completed_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return ExpensePlan.fromJson(response);
    } catch (e) {
      throw Exception('Failed to mark expense plan as completed: $e');
    }
  }

  // Get summary untuk tanggal tertentu
  Future<double> getTotalAmountForDate(String userId, DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await _client
          .from('expense_plans')
          .select('amount')
          .eq('user_id', userId)
          .eq('planned_date', dateStr);

      final total = (response as List).fold<double>(
        0,
        (sum, item) => sum + (item['amount'] as num).toDouble(),
      );

      return total;
    } catch (e) {
      return 0;
    }
  }

  // Get total amount untuk minggu tertentu
  Future<double> getTotalAmountForWeek(String userId, DateTime startDate) async {
    try {
      final endDate = startDate.add(const Duration(days: 7));
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      final response = await _client
          .from('expense_plans')
          .select('amount')
          .eq('user_id', userId)
          .gte('planned_date', startStr)
          .lt('planned_date', endStr);

      final total = (response as List).fold<double>(
        0,
        (sum, item) => sum + (item['amount'] as num).toDouble(),
      );

      return total;
    } catch (e) {
      return 0;
    }
  }

  // Get total amount untuk bulan tertentu
  Future<double> getTotalAmountForMonth(
    String userId,
    int year,
    int month,
  ) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      final response = await _client
          .from('expense_plans')
          .select('amount')
          .eq('user_id', userId)
          .gte('planned_date', startStr)
          .lte('planned_date', endStr);

      final total = (response as List).fold<double>(
        0,
        (sum, item) => sum + (item['amount'] as num).toDouble(),
      );

      return total;
    } catch (e) {
      return 0;
    }
  }
}
