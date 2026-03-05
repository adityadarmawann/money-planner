# PRE-RELEASE VALIDATION - MONEY PLANNER v1.0

**Status:** 🟡 Ready for Manual QA Testing  
**Build Date:** March 5, 2026  
**Target Release:** After QA Sign-Off  

---

## QUICK CHECKLIST (5 Minute Review)

### Code Quality
- [✅] `flutter analyze` - No issues found
- [✅] `flutter test` - 3/3 passing
- [✅] No compile errors
- [✅] No lint warnings
- [✅] Strict sync implemented (rollback on failure)

### Features Verified (Code Review)
- [✅] CRUD Expense Planner with calendar sync
- [✅] Transfer: User, Bank, QRIS
- [✅] PayLater: Create, Pay, Track
- [✅] Self-transfer prevention
- [✅] Insufficient balance checks
- [✅] Calendar permission handling
- [✅] Error handling with user-friendly messages

---

## CRITICAL FLOWS (Must Test Before Release)

### Flow 1: Create Expense Plan ⭐ PRIMARY
**Steps:**
1. Open app → Navigate to Calendar icon (top-right)
2. Click "+" button
3. Fill form: Title, Amount, Category, Date, Reminder
4. Click "Simpan"
5. ✅ Verify: Plan appears in calendar AND device calendar

**Acceptance Criteria:**
- Plan shows on correct date in calendar view
- Plan appears in device calendar app (Settings > Calendars can verify)
- Amount formatted with "Rp" prefix
- Main "My Plan" list updated (if same month)

**Risk:** Calendar sync must 100% succeed or entire operation fails

---

### Flow 2: Transfer to User ⭐ CRITICAL
**Steps:**
1. Open Dompet screen
2. Click "Transfer ke Pengguna"
3. Enter recipient username (e.g., "testuser2")
4. Click "Cari"
5. ✅ Verify: User found, display name shown
6. Enter amount (e.g., 100,000)
7. Add note (optional)
8. Click "Transfer"
9. Confirm on next screen
10. ✅ Verify: Success message, balance decreased

**Acceptance Criteria:**
- Recipient name displays after search
- Amount validation prevents > balance
- Prevents transfer to self
- Balance updates immediately
- Recipient balance updates (can check on their device)
- Transaction appears in history

**High-Risk Items:**
- [ ] Is username search case-insensitive? (Code not visible)
- [ ] Can transfer amount = exactly wallet balance? (Test edge case)

---

### Flow 3: Bank Transfer ⭐ IMPORTANT
**Steps:**
1. Open Dompet screen
2. Click "Transfer ke Bank"
3. Select bank (e.g., "BCA")
4. Select account or enter new
5. Enter amount
6. Click "Transfer"
7. ✅ Verify: Fee calculated and shown

**Acceptance Criteria:**
- Amount + fee = total deduction from balance
- Fee amount clearly displayed
- Account number masked for security (e.g., "****6789")
- Success confirmation with receipt

---

### Flow 4: QRIS Payment 🔍 HIGHEST RISK
**Steps:**
1. Open Dompet screen
2. Click "QRIS"
3. Scan QRIS code (or select test image)
4. Merchant name auto-fills
5. Amount auto-fills (allow edit)
6. Click "Bayar"
7. ✅ Verify: Payment processed, receipt shown

**Acceptance Criteria:**
- Valid QRIS recognized and parsed
- Invalid image shows error (not crash)
- Amount can be edited without limits (⚠️ VERIFY: Should there be limits?)
- Receipt shows merchant, amount, date

**High-Risk Items:**
- [ ] QRIS image upload size limits? (Could cause crash)
- [ ] Amount override safely capped? (Could allow fraud)
- [ ] Receipt generation works? (May be unimplemented)

---

### Flow 5: Edit Expense Plan 📝
**Steps:**
1. Open Calendar view
2. Click plan card
3. Click edit icon (pencil)
4. Edit any field (title, amount, date, reminder)
5. Click "Simpan"
6. ✅ Verify: Changes appear in calendar

**Acceptance Criteria:**
- All fields editable
- Calendar event updates (not duplicated)
- Auto-refresh applies changes
- Rollback if calendar sync fails

---

### Flow 6: Delete Expense Plan 🗑️
**Steps:**
1. Open Calendar view
2. Click plan card
3. Click delete icon (trash)
4. Confirm deletion
5. ✅ Verify: Plan removed from calendar AND device calendar

**Acceptance Criteria:**
- Confirmation dialog shows plan name
- Plan disappears from both calendars
- Undo snackbar shows (optional)

---

### Flow 7: PayLater Management
**Steps:**
1. Open PayLater screen
2. Click "Pinjam Sekarang"
3. Enter amount + tenor (months)
4. Click "Ajukan"
5. ✅ Verify: Bill created, appears in active bills

**Acceptance Criteria:**
- Bill amount + calculated fee = total debt
- Correct tenor months shown
- Bill status: "Active" or "Overdue"
- Can mark as paid or delete

---

## DEVICE CALENDAR SYNC VERIFICATION

**Critical:** Calendar sync must succeed 100% for create/update to work

### Test on Device:
1. **Before Testing:**
   - Open device Calendar app
   - Note current events count

2. **Create Plan:**
   - Create "Test Expense 1" for tomorrow
   - Open device Calendar app
   - Refresh / pull down to sync
   - ✅ Verify: "💸 Test Expense 1" appears as all-day event

3. **Edit Plan:**
   - Edit "Test Expense 1" amount to 500,000
   - Open device Calendar app
   - ✅ Verify: Amount in description updated (or event recreated)

4. **Delete Plan:**
   - Delete "Test Expense 1"
   - Open device Calendar app
   - ✅ Verify: Event removed

**Acceptance:** All 3 operations (create, edit, delete) sync 100% to device calendar

---

## EDGE CASE TESTING

### Amount Handling
```
✅ Test Cases:
- Enter: 1 (minimum)
- Enter: 999,999,999 (maximum)
- Enter: 0 (invalid - should reject)
- Enter: -100 (invalid - should reject)
- Enter: 1,000,000.50 (decimal - should work)
- Transfer: amount exactly = wallet balance
- Transfer: amount + 1 > wallet balance (should reject)
```

### Date Handling
```
✅ Test Cases:
- Set plan date 5 years in past ✅ (picker allows)
- Set plan date 5 years in future ✅ (picker allows)
- Set plan date to today ✅
- Set plan date to yesterday ✅ (historical entry)
- Leap year: Feb 29 (if applicable)
```

### Text Handling
```
✅ Test Cases:
- 100+ character title (should truncate with ellipsis)
- Special characters in title: @, #, $, &, emoji
- Very long notes (1000+ chars - should all display in modal)
- Empty notes (optional field - should allow)
```

---

## OFFLINE & NETWORK RESILIENCE

### Offline Scenario
```
1. Close WiFi/4G
2. Try creating plan → Should show "No internet" error
3. Try transferring to user → Should show "No internet" error
4. Turn internet back on → Actions retry successfully
```

### Network Instability
```
1. Create plan while on poor connection
2. Monitor: Watch for "Sync failed" message (if sync times out)
3. Verify: Can retry operation
```

---

## PERFORMANCE BASELINE

### Load Times (Target)
- App startup: < 3 seconds ✅
- Plan list load: < 1 second ✅
- Calendar view: < 1.5 seconds ✅
- Search user: < 2 seconds
- Transfer processing: < 5 seconds

### Memory (Visual Check)
- No app freeze during rapid scrolling
- Smooth animations (60 FPS target)
- No "App Not Responding" dialogs

---

## SECURITY CHECKLIST

### Data Privacy
- [ ] Only own plans visible (no data leakage)
- [ ] Only own transfers shown
- [ ] Cannot see other user's balance
- [ ] Cannot view other user's bank accounts

### Input Validation
- [ ] No SQL injection via username search
- [ ] No XSS via note fields
- [ ] File uploads (if QRIS image) validated

### Session Security
- [ ] Logout clears sensitive data
- [ ] Token expiry handled
- [ ] No plaintext passwords in logs

---

## FINAL GO-NO-GO DECISION

### Release Blockers (ANY ❌ = NO RELEASE)
- ❌ Calendar sync failures (must be 100%)
- ❌ Crashes or force closes
- ❌ Data loss on edit/delete
- ❌ Duplicate transactions (race condition)
- ❌ Incorrect balance calculations
- ❌ Cannot transfer to valid user

### Minor Issues (Can Release With Notes)
- ⚠️ QRIS receipt generation missing (non-critical)
- ⚠️ Overdue bill highlighting not obvious
- ⚠️ Reminder notification not tested (system-level feature)

---

## SIGN-OFF TEMPLATE

```
QA TESTING SESSION LOG
======================

Date: ___________
Tester: ________
Device/OS: ________________
Build Version: _____________

FLOWS TESTED:
- [ ] Create Expense Plan - Status: [✅/⚠️/❌]
- [ ] Update Expense Plan - Status: [✅/⚠️/❌]
- [ ] Delete Expense Plan - Status: [✅/⚠️/❌]
- [ ] Transfer to User - Status: [✅/⚠️/❌]
- [ ] Bank Transfer - Status: [✅/⚠️/❌]
- [ ] QRIS Payment - Status: [✅/⚠️/❌]
- [ ] PayLater Bill - Status: [✅/⚠️/❌]
- [ ] Calendar Sync - Status: [✅/⚠️/❌]

ISSUES FOUND:
1. ___________________________
2. ___________________________
3. ___________________________

BLOCKERS: ⏳ NONE / ⚠️ [list] / ❌ FOUND

APPROVED FOR RELEASE: [YES/NO/WITH NOTES]

Notes: ___________________________________

Signature: _________________ Date: _______
```

---

## RESOURCES

📱 **QA_CHECKLIST.md** - Comprehensive scenario-based checklist  
🔍 **AUDIT_FINDINGS.md** - Technical deep-dive and risk analysis  
📋 **This Document** - Pre-release summary and sign-off

---

**Next Steps:**
1. Print/save this document
2. Follow QA_CHECKLIST systematically
3. Document any issues in AUDIT_FINDINGS format
4. Decision: Release or iterate

**Estimated QA Time:** 2-3 hours (comprehensive testing)  
**Critical Path Testing:** 30 minutes (must-pass flows only)

---

Ready for QA! 🚀
