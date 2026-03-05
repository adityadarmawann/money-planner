# Code Audit & Focus Areas - Manual QA Testing

**Audit Date:** March 5, 2026  
**Reviewed Components:** TransactionProvider, PayLaterProvider, ExpensePlanProvider, TransferScreen

---

## 1. TRANSFER FEATURES - AUDIT FINDINGS

### 1.1 Transfer to User (transfer_screen.dart lines 368-429)
**Code Review Results:**
```dart
if (senderId == _recipient!.id) {
  showSpSnackbar(context, 'Tidak bisa transfer ke diri sendiri',
      isError: true);
  return;
}
```
✅ **PASS:** Self-transfer prevention implemented

**Edge Cases to Test:**
1. **Username Search Case Sensitivity** 
   - Code: `await userRepo.getUserByUsername(username)`
   - Expected: Search should be case-insensitive
   - **Action:** Test "john" = "JOHN" = "John"
   - Risk Level: ⚠️ Medium (depends on database query implementation)

2. **Username with Special Characters**
   - Test: "user@123", "user.name", "user_name"
   - Expected: Search and find user correctly
   - **Action:** Verify username search SQL injection safety

3. **Empty Recipient Check**
   - Code: `if (_recipient == null) { showSnackbar... }`
   - Expected: Cannot submit without recipient
   - **Action:** Try clicking Transfer button without searching first
   - Status: ✅ Implemented

4. **Self-Transfer Prevention**
   - Code: `if (senderId == _recipient!.id) { showSnackbar... }`
   - Expected: Prevent transfer to self
   - **Action:** Search for own username, verify error shown
   - Status: ✅ Implemented

5. **Insufficient Balance Check**
   - Code: `if (amount > walletProvider.balance) { showSnackbar... }`
   - Expected: Show "Saldo tidak cukup"
   - **Action:** Transfer more than available balance
   - Status: ✅ Implemented

6. **Receiver Wallet Exists**
   - Code: `receiverWallet = await walletRepo.getWallet(...)`
   - Risk: What if recipient has no wallet? (New user edge case)
   - **Action:** Test transferring to user with no wallet
   - **Expected:** Show "Wallet penerima tidak ditemukan"
   - Status: ✅ Implemented

7. **Zero/Negative Amount**
   - Code: `if (amount <= 0) { showSnackbar... }`
   - Expected: Validation error shown
   - **Action:** Enter 0, -100, clear field
   - Status: ✅ Implemented

8. **Network Error During Search**
   - Code: `catch (e) { ... showSnackbar(...) }`
   - Expected: Error message shown, can retry
   - **Action:** Turn off WiFi, search user
   - Status: ✅ Handled with try-catch

---

### 1.2 Bank Transfer (transaction_provider.dart line 119)
**Code Review Results:**
```dart
Future<bool> bankTransfer({
  required String userId,
  required String walletId,
  required double amount,
  required double fee,
  required String bankName,
  required String accountNumber,
  String? note,
})
```
✅ **PASS:** Fee calculation included

**Edge Cases to Test:**
1. **Fee Application Logic**
   - Expected: Amount + fee = total deduction
   - **Action:** Transfer 100,000 with 2,500 fee, verify balance = -102,500
   - Risk: ⚠️ Medium (depends on implementation)

2. **Account Number Validation**
   - Expected: Must validate format (e.g., 6-16 digits for BCA)
   - **Action:** Enter "123" (too short), "abc" (invalid)
   - Risk: ⚠️ Medium (validation may be missing in UI)

3. **Bank Name Selection**
   - Expected: Dropdown prevents typos
   - **Action:** Verify all banks listed correctly
   - Status: Depends on UI implementation

4. **Amount > Balance + Fee**
   - Expected: Reject if amount + fee > balance
   - **Action:** Test edge case where balance = amount but fee not covered
   - Risk: ⚠️ Medium-High

---

### 1.3 QRIS Payment (qris_payment_screen.dart)
**Code Review Results:**
```dart
Future<bool> qrisPayment({
  required String userId,
  required String walletId,
  required double amount,
  required String merchantName,
})
```
🔍 **NEEDS TESTING:** Amount editability

**Edge Cases to Test:**
1. **Invalid QRIS Image**
   - Expected: Show "Invalid QRIS code"
   - **Action:** Upload non-QRIS image (photo, document)
   - Risk: ⚠️ High (OCR/validation critical)

2. **Edited QRIS Amount**
   - Expected: Can override amount before payment
   - **Action:** Scan QRIS with 50,000, change to 75,000
   - Risk: ⚠️ High (could allow overpayment or underpayment)

3. **Merchant Extraction**
   - Expected: Merchant name parsed correctly from QRIS
   - **Action:** Scan valid QRIS, verify merchant name
   - Risk: ⚠️ Medium (depends on QRIS parsing accuracy)

4. **Receipt Generation**
   - Expected: Downloadable/shareable receipt
   - **Action:** Complete payment, check receipt options
   - Risk: ⚠️ Medium (requires proper file generation)

---

## 2. PAYLATER FEATURE - AUDIT FINDINGS

### 2.1 Disburse PayLater
**Code Review Results:**
```dart
Future<bool> disbursePaylater({
  required String userId,
  required String walletId,
  required double amount,
  required int tenorMonths,
})
```
✅ **PASS:** Tenor months included

**Edge Cases to Test:**

1. **Valid Tenor Range**
   - Expected: Support 3, 6, 12 months (typical)
   - **Action:** Try 1 month, 24 months, 0 months
   - Risk: ⚠️ Medium (UI may not validate)

2. **Fee Calculation on Disbursement**
   - Expected: Interest/fee applied based on tenor
   - **Action:** Disburse 1,000,000 for 12 months, verify fee calculation
   - Risk: ⚠️ High (complex interest calculation)

3. **Account Credit Limit Check**
   - Expected: Cannot exceed credit limit
   - **Action:** Try disbursing more than available limit
   - Risk: ⚠️ Medium (validation may be missing)

4. **Bill Creation**
   - Code: `final bill = result['bill'] as PaylaterBillModel;`
   - Expected: Bill created and appears in list immediately
   - **Action:** Disburse, refresh, verify bill in active list
   - Status: ✅ Implemented

---

### 2.2 Pay Bill Payment Logic
**Code Review Results:**
```dart
final idx = _bills.indexWhere((b) => b.id == billId);
if (idx != -1) _bills[idx] = updatedBill;
```
✅ **PASS:** Proper list update, prevents index errors

**Edge Cases to Test:**

1. **Partial Payment (if supported)**
   - Expected: Allow or prevent partial payment
   - **Action:** Bill for 1,000,000, try paying 500,000
   - Risk: ⚠️ High (depends on business logic)

2. **Overpayment (if supported)**
   - Expected: Allow or prevent paying more than bill amount
   - **Action:** Bill for 1,000,000, try paying 1,500,000
   - Risk: ⚠️ Medium

3. **Double Payment Prevention**
   - Expected: Cannot pay already-paid bill
   - **Action:** Mark bill as paid, try paying again
   - Risk: ⚠️ High-Critical (must prevent fraud)

4. **Bill Status Transitions**
   - Expected: Bill status: active → overdue → paid (correct sequence)
   - **Action:** Check bill status calculations in provider
   - Risk: ⚠️ Medium (status logic in PaylaterRepository)

---

## 3. EXPENSE PLAN CRUD - AUDIT FINDINGS

### 3.1 Create Expense Plan (Strict Calendar Sync)
**Code Review Results:**
```dart
try {
  final plan = await _repository.createExpensePlan(...);
  
  // Strict sync to device calendar
  try {
    await _calendarService.ensureSyncExpensePlanToCalendar(plan);
  } catch (e) {
    // Rollback DB insert jika sync kalender gagal
    await _repository.deleteExpensePlan(plan.id);
    rethrow;
  }
  
  _expensePlans.add(plan);
  return true;
}
```
✅ **PASS:** Strict sync with rollback implemented

**Edge Cases to Test:**

1. **Calendar Permission Denied**
   - Expected: Create fails with "Sync failed, try again"
   - **Action:** Deny calendar permission, try creating plan
   - Test: Go back, grant permission in settings, create plan
   - Status: ✅ Handled

2. **Calendar Sync Succeeds, DB Insert Succeeds**
   - Expected: Plan visible in list and calendar
   - **Action:** Create plan, verify appears in 2 places
   - Status: ✅ Expected behavior

3. **DB Insert Succeeds, Calendar Sync Fails**
   - Expected: DB insert rolled back, user sees error
   - **Action:** Simulate: network off → calendar offline, create (should fail)
   - Status: ✅ Rollback implemented

4. **Duplicate Prevention**
   - Expected: Cannot create identical plan twice in same minute
   - **Action:** Quickly create 2 identical plans
   - Risk: ⚠️ Low (timestamp should differ)

---

### 3.2 Update Expense Plan (Rollback Logic)
**Code Review Results:**
```dart
final index = _expensePlans.indexWhere((p) => p.id == id);
final previousPlan = index >= 0 ? _expensePlans[index] : null;

final updated = await _repository.updateExpensePlan(id, updates);

// Strict sync updated plan to calendar
try {
  await _calendarService.ensureSyncExpensePlanToCalendar(updated);
} catch (e) {
  // Rollback DB update jika sync kalender gagal
  if (previousPlan != null) {
    const rollbackUpdates = { ... };
    await _repository.updateExpensePlan(id, rollbackUpdates);
    _expensePlans[index] = previousPlan;
  }
  rethrow;
}
```
⚠️ **CONCERN:** Rollback map missing ISO string parsing for date

**Edge Cases to Test:**

1. **Update Planned Date**
   - Expected: Calendar event updated to new date
   - **Action:** Change planned date from March 5 to March 15
   - Verify: Event on calendar moves to correct date
   - Status: ✅ Sync implemented

2. **Update Amount**
   - Expected: Calendar event description updated with new amount
   - **Action:** Change 100,000 to 150,000
   - Verify: Calendar event shows new amount in description
   - Status: ✅ Should work (sync includes full plan)

3. **Update Reminder Type**
   - Expected: Reminder notifies at new time
   - **Action:** Change from "24 hours" to "custom 12 hours"
   - Verify: Device calendar shows updated time
   - Status: ⚠️ Calendar integration may not support reminder updates

4. **Sync Fails, Rollback Triggered**
   - Expected: DB reverted to previous state
   - **Action:** Edit plan, turn off network mid-sync
   - Verify: Plan data unchanged after error
   - Risk: ⚠️ Medium (requires network timing control)

---

### 3.3 Delete Expense Plan (Transaction Order)
**Code Review Results:**
```dart
try {
  // Strict delete from calendar first
  await _calendarService.ensureDeleteExpensePlanByPlanId(id);
  
  await _repository.deleteExpensePlan(id);
  
  _expensePlans.removeWhere((p) => p.id == id);
  return true;
}
```
✅ **PASS:** Delete calendar first prevents orphaned events

**Edge Cases to Test:**

1. **Calendar Delete Fails, DB Not Deleted**
   - Expected: Error shown, plan remains in DB
   - **Action:** Delete plan, verify error handling
   - Status: ✅ Implemented (no DB delete on calendar fail)

2. **Calendar Delete Succeeds, DB Delete Fails**
   - Expected: Event removed from calendar, but plan still in DB
   - Risk: ⚠️ Medium (inconsistency possible)
   - **Action:** Monitor: Try deleting, check calendar and DB state

3. **Delete Non-Existent Plan**
   - Expected: Graceful error, no crash
   - **Action:** Manually delete plan from DB, try deleting from UI
   - Risk: ⚠️ Medium (depends on exception handling)

---

### 3.4 Toggle Completion
**Code Review Results:**
```dart
Future<bool> toggleCompleted(String id, bool currentStatus) async {
  try {
    final updated = await _repository.toggleCompleted(id, currentStatus);
    final index = _expensePlans.indexWhere((p) => p.id == id);
    if (index >= 0) {
      _expensePlans[index] = updated;
    }
    notifyListeners();
    return true;
  }
}
```
✅ **PASS:** Simple toggle without complex sync issues

**Edge Cases to Test:**

1. **Mark Completed Then Edit**
   - Expected: Can still edit completed plan
   - **Action:** Mark plan done, click edit, change amount
   - Status: ✅ Should allow (view code confirms)

2. **Toggle Multiple Times Quickly**
   - Expected: State remains consistent
   - **Action:** Rapidly click checkbox 5 times
   - Verify: Final state matches actual DB state
   - Risk: ⚠️ Low (simple toggle)

3. **Completion Date Set**
   - Expected: `completed_at` timestamp recorded
   - **Action:** Mark plan done, check completion timestamp
   - Status: ⚠️ Depends on implementation

---

## 4. DATA SYNCHRONIZATION RISKS

### 4.1 Race Conditions
**Risk Areas:**
1. **Rapid Create-Update-Delete**
   - Create plan → Update amount → Delete
   - Expected: Handle out-of-order operations gracefully
   - Testing: Use automated script with 3 operations/second

2. **Offline Queue + Sync**
   - Edit plan while offline → Go online → Sync triggers
   - Risk: ⚠️ Medium (complex to test manually, needs integration tests)

### 4.2 Calendar Sync Integrity
**Risk Areas:**
1. **Multi-device Sync**
   - Create plan on Phone A → Check Device Calendar on Phone B
   - Risk: ⚠️ High (if cloud sync not tested)

2. **Calendar Event Format**
   - Expected: Title "💸 [Plan Title]" consistent
   - Verify: All calendar events have emoji prefix
   - Risk: ⚠️ Low (implementation is hardcoded)

---

## 5. UI/FORM VALIDATION GAPS

### 5.1 Transfer to User Screen
**Validation Status:**
- ✅ Empty recipient search → Show snackbar
- ✅ Self-transfer → Show snackbar  
- ✅ Zero/negative amount → Show snackbar
- ✅ Insufficient balance → Show snackbar
- ❓ Long username (100+ chars) → Trim/validate?
- ❓ Username with emoji → Handle?
- ❓ HTML in notes field → Escape?

### 5.2 Bank Transfer Form
**Validation Status:**
- ❓ Account number format validation → Missing?
- ❓ Bank name pre-filled from dropdown → Secure?
- ❓ Fee amount visibility → Clear?

### 5.3 QRIS Payment
**Validation Status:**
- ❓ Amount override safety → Limits?
- ❓ QRIS image size → Limits?
- ❓ Parsing accuracy → Tested?

### 5.4 Plan CRUD Forms
**Validation Status:**
- ✅ Title not empty → Required field
- ✅ Amount > 0 → Validated
- ✅ Category selected → Required dropdown
- ✅ Reminder type selected → Default or custom
- ✅ Custom reminder > 0 → Validated
- ✅ Date 5 years back/forward → Picker bounds

---

## 6. CRITICAL TESTING PATHS

### Priority 1 (Must Pass)
- [ ] Create expense plan + appears in calendar + device calendar
- [ ] Update expense plan + calendar syncs
- [ ] Delete expense plan + removed from calendar
- [ ] Transfer to user + balance updates both parties
- [ ] Bank transfer + fee deducted correctly
- [ ] Create PayLater bill + appears in list

### Priority 2 (Should Pass)
- [ ] QRIS scan + amount editable + payment works
- [ ] Mark plan completed + hides from main list
- [ ] Edit completed plan + still stays completed
- [ ] Delete confirmation dialog + shows plan name
- [ ] User search case-insensitive
- [ ] Insufficient balance error

### Priority 3 (Nice to Have)
- [ ] Calendar event includes description (category, amount, source)
- [ ] Overdue PayLater bills highlighted
- [ ] Receipt generation for transfers
- [ ] Transaction history filters by type

---

## 7. RECOMMENDED TEST DATA

**Test User 1 (Sender):**
- Username: `testuser1`
- Balance: Rp 5,000,000
- Wallet: Ready
- Permissions: Granted

**Test User 2 (Receiver):**
- Username: `testuser2`
- Balance: Rp 0 (to test receipt)
- Wallet: Ready

**Test Data Setup:**
```
Transfer Tests:
- User-to-User: 1,000,000
- User-to-User: 0 (invalid)
- User-to-User: 6,000,000 (insufficient balance)
- User-to-User: Self (prevention test)

Bank Transfer:
- Valid account (6-16 digits)
- Bank: Mandiri, BCA, BNI

QRIS Tests:
- Valid QRIS code image (amount 250,000)
- Invalid image (photo)

Expense Plan Tests:
- Create 5 plans for current month
- 3 completed, 2 active
- Various categories and amounts

PayLater Tests:
- 1 active bill (500,000)
- 1 overdue bill (1,000,000)
- 1 paid bill (completed)
```

---

## 8. GO-NO-GO CHECKLIST

Before Release Approval:
- [ ] All Priority 1 tests passed
- [ ] No crashes or force closes
- [ ] All error messages user-friendly
- [ ] Network error recovery works
- [ ] Offline data persists
- [ ] Permissions properly requested
- [ ] No concurrent operation conflicts
- [ ] Balance calculations accurate
- [ ] Calendar sync 100% (no orphaned events)
- [ ] No memory leaks (use AppQoS)

---

**Prepared by:** Code Audit Agent  
**Date:** March 5, 2026  
**Next Step:** Execute manual testing with this focus areas
