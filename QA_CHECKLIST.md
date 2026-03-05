# QA Checklist - Money Planner v1.0

**Test Date:** ___________  
**Tester:** ___________  
**Device/Emulator:** ___________  
**Status:** ⏳ (Pending / ✅ Pass / ❌ Failed)

---

## 1. TRANSFER FEATURES

### 1.1 Transfer to User (Peer-to-Peer)
- [ ] **Search user by username** - Type valid username, results shown
- [ ] **Search user case-insensitivity** - Search "John" = "john" = "JOHN"
- [ ] **Search user with special chars** - Handle username with dots/underscores
- [ ] **Search non-existent user** - Shows "User not found" clearly
- [ ] **Select user from results** - User details pre-filled in form
- [ ] **Enter valid amount** - Accept 1 to 999,999,999
- [ ] **Enter 0 or negative amount** - Show validation error, prevent submit
- [ ] **Enter amount > balance** - Show validation error, prevent submit
- [ ] **Add description/notes** - Optional field saves correctly
- [ ] **Submit transfer to user** - Success message + receipt shown
- [ ] **Transfer appears in history** - Correct sender/receiver, amount, date
- [ ] **Recipient receives notification** - (If applicable)
- [ ] **Recipient balance updates** - Real-time or on refresh
- [ ] **Cannot transfer to self** - Show validation error
- [ ] **Network error handling** - Graceful error message, allow retry

### 1.2 Transfer to Bank Account
- [ ] **Bank account list loads** - Shows saved bank accounts
- [ ] **Add new bank account** - Bank name, account number, holder name
- [ ] **Validate account number format** - Reject invalid formats
- [ ] **Select from list** - Pre-fill bank and account details
- [ ] **Enter valid amount** - Process normally
- [ ] **Enter amount > balance** - Show validation error
- [ ] **Add notes/reference** - Save with transfer
- [ ] **Submit bank transfer** - Success confirmation shown
- [ ] **Bank transfer in history** - Show correct bank name, account (masked), amount
- [ ] **Fee calculation** - Correct fee applied if applicable
- [ ] **Balance deducted correctly** - Amount + fee = total deduction
- [ ] **Network error handling** - Allow retry on failure

### 1.3 QRIS Transfer
- [ ] **QRIS payment screen opens** - Camera/gallery option shown
- [ ] **Scan QRIS code from camera** - Parse merchant name and amount
- [ ] **Upload QRIS image from gallery** - Parse and validate
- [ ] **Invalid QRIS image** - Show "Invalid QRIS code" message
- [ ] **Pre-filled merchant name** - From QRIS data
- [ ] **Pre-filled amount** - From QRIS data (allow edit)
- [ ] **Edit amount before submit** - Allow override
- [ ] **Amount > balance** - Show validation error
- [ ] **Submit QRIS payment** - Success message shown
- [ ] **QRIS transaction in history** - Show merchant, amount, date
- [ ] **Receipt generation** - Downloadable or shareable
- [ ] **Network error** - Retry available

---

## 2. PAYLATER FEATURE

### 2.1 Create Pay Later Entry
- [ ] **Add new pay later** - Form opens with blank fields
- [ ] **Enter merchant name** - Text input accepts characters
- [ ] **Enter amount** - Accepts positive numbers, validation on negative/0
- [ ] **Set due date** - Date picker opens, can select future dates
- [ ] **Set reminder** - Default/custom reminder options work
- [ ] **Add notes** - Optional notes field saves
- [ ] **Submit form** - Entry created, list refreshes
- [ ] **Entry appears in list** - Shows merchant, amount, due date
- [ ] **Calendar sync** - Entry synced to device calendar (if enabled)

### 2.2 Mark as Paid
- [ ] **Mark as paid from list** - Checkbox/button toggles completion
- [ ] **Paid entry styling** - Strikethrough or different styling shown
- [ ] **Paid entry still visible** - Not removed from list
- [ ] **Toggle back to unpaid** - Can revert if needed
- [ ] **Undo paid action** - Snackbar shows, data consistent

### 2.3 Edit Pay Later Entry
- [ ] **Open edit form** - Current data pre-filled
- [ ] **Edit merchant name** - Changes save correctly
- [ ] **Edit amount** - Changes save, validation works
- [ ] **Edit due date** - Date picker opens with current date highlighted
- [ ] **Edit reminder** - Reminder type/hours update
- [ ] **Submit edit** - Changes persist in list
- [ ] **Calendar sync on edit** - Device calendar updated

### 2.4 Delete Pay Later Entry
- [ ] **Delete button/action** - Confirmation dialog shown
- [ ] **Confirm deletion** - Entry removed from list
- [ ] **Cancel deletion** - Entry remains unchanged
- [ ] **Undo feedback** - Snackbar shows "Deleted" message
- [ ] **Calendar cleanup** - Deleted event removed from device calendar

### 2.5 Pay Later Notifications/Reminders
- [ ] **Overdue entries** - Highlighted in red/orange
- [ ] **Due today** - Special styling applied
- [ ] **Upcoming (next 3 days)** - Visual indicator shown
- [ ] **Reminder notification** - Arrives at specified time

---

## 3. EXPENSE PLAN (CRUD) - PRIMARY FEATURE

### 3.1 Create Expense Plan
- [ ] **Navigate to calendar** - Click calendar icon on main page
- [ ] **Create new plan button** - Opens form with empty fields
- [ ] **Enter plan title** - Text input works
- [ ] **Enter amount** - Numeric validation, positive only
- [ ] **Select category** - Dropdown shows all categories
- [ ] **Select payment source** - Dropdown shows all sources (bank, e-wallet, cash, etc)
- [ ] **Set planned date** - Date picker opens, can select 5 years back to 5 years forward
- [ ] **Set reminder type** - Default/1 hour/3 hours/24 hours/custom
- [ ] **Custom reminder hours** - Input accepts numbers > 0, validation on ≤ 0
- [ ] **Add notes** - Optional notes field
- [ ] **Submit form** - Plan created, calendar view refreshes
- [ ] **Plan appears on calendar** - Correct date, showing amount
- [ ] **Plan in device calendar** - Synced to device calendar with title "💸 [Plan Title]"
- [ ] **Title character limit** - Works with long titles (ellipsis if needed)

### 3.2 Read/View Expense Plans
- [ ] **Main page "My Plan"** - Shows only non-completed plans for current month
- [ ] **Plan card shows title** - Correct text
- [ ] **Plan card shows amount** - Currency formatted (Rp X,XXX)
- [ ] **Plan card shows category** - Correct category icon/name
- [ ] **Plan card shows date** - Correct formatted date
- [ ] **Plan card shows source** - Payment source displayed
- [ ] **Completed plans hidden** - Not shown in main page list
- [ ] **Calendar view shows all** - Both completed and non-completed
- [ ] **Completed plans styled** - Strikethrough text, different color
- [ ] **Plan details modal** - Can view notes, reminder info, full details
- [ ] **Badge count accurate** - Top-right calendar badge shows correct count
- [ ] **Empty state** - Shows "No plans" message when empty

### 3.3 Update Expense Plan
- [ ] **Navigate to calendar** - View expense plans
- [ ] **Open edit form** - Click edit icon on plan card
- [ ] **Form pre-filled** - All fields show current data
- [ ] **Edit title** - Change and save
- [ ] **Edit amount** - Change confirms validation
- [ ] **Edit category** - Dropdown opens with current selected
- [ ] **Edit payment source** - Changes to different source
- [ ] **Edit planned date** - Date picker shows current date highlighted
- [ ] **Edit reminder type** - Change from custom to preset works
- [ ] **Edit custom reminder hours** - Can update custom hours
- [ ] **Submit edit** - Changes persist in list and calendar
- [ ] **Calendar event updated** - Device calendar reflects changes
- [ ] **Main page refreshes** - If applicable to current month
- [ ] **Edit non-completed plan** - Works normally
- [ ] **Edit completed plan** - Can edit even if marked done

### 3.4 Delete Expense Plan
- [ ] **Delete button visible** - In calendar view (not in main list)
- [ ] **Confirm dialog** - Shows plan title in confirmation message
- [ ] **Confirm deletion** - Plan removed from list and calendar
- [ ] **Cancel deletion** - Plan remains unchanged
- [ ] **Undo feedback** - Snackbar confirms deletion
- [ ] **Calendar event deleted** - Removed from device calendar
- [ ] **Delete non-completed plan** - Works
- [ ] **Delete completed plan** - Can delete
- [ ] **Badge count updates** - Decrements correctly

### 3.5 Toggle Plan Completion
- [ ] **Toggle checkpoint** - Click checkbox to mark complete
- [ ] **Completion styling** - Strikethrough applied
- [ ] **Immediate feedback** - Snackbar shows success
- [ ] **Plan moves/hides** - If applicable (hides from main list)
- [ ] **Toggle back** - Can mark incomplete again
- [ ] **On calendar view** - Completed status persists after refresh
- [ ] **On main page** - Completed plans don't appear in list

---

## 4. CALENDAR INTEGRATION (STRICT SYNC)

### 4.1 Device Calendar Sync
- [ ] **Permission request** - App asks for calendar permission on first use
- [ ] **Create plan syncs** - Event appears in device calendar immediately
- [ ] **Event format correct** - Title: "💸 [Plan Title]", time: 09:00-10:00
- [ ] **Event includes details** - Description shows category, amount, source
- [ ] **Event timezone correct** - Asia/Jakarta (WIB)
- [ ] **Update plan syncs** - Calendar event updated
- [ ] **Delete plan deletes event** - Calendar event removed
- [ ] **Sync failure prevention** - If calendar sync fails, plan creation fails (strict mode)
- [ ] **Rollback on sync failure** - If update fails, reverts to previous state
- [ ] **Error message** - Shows "Sync failed, try again" or similar
- [ ] **Retry mechanism** - Can retry failed syncs

### 4.2 Calendar Permissions
- [ ] **First app launch** - Permission dialog shown
- [ ] **Grant permission** - Sync works
- [ ] **Deny permission** - Plan creation shows error message
- [ ] **Permission requests again** - If denied previously
- [ ] **Settings > Permissions** - Can manage calendar permission

---

## 5. DATA CONSISTENCY & EDGE CASES

### 5.1 Offline Scenarios
- [ ] **Turn off network** - App shows network error gracefully
- [ ] **Cached data shown** - Previously loaded data still visible
- [ ] **Retry on action** - Actions show error, allow retry
- [ ] **Turn network back on** - Sync/refresh works
- [ ] **No data loss** - All edits preserved (if queued locally)

### 5.2 Large Amounts
- [ ] **Amount = 999,999,999** - Accepted without error
- [ ] **Amount > 999,999,999** - Rejected or capped with message
- [ ] **Decimal amounts** - Handled correctly (e.g., 10,500.50)
- [ ] **Currency display** - Formatted consistently (Rp notation)

### 5.3 Long Text Inputs
- [ ] **Plan title 100+ chars** - Accepted, displays with ellipsis
- [ ] **Merchant name long** - Truncated appropriately
- [ ] **Notes/description long** - Full text visible in details modal
- [ ] **No text overflow** - Layout remains clean

### 5.4 Date Boundary Cases
- [ ] **Plan dated today** - Works correctly
- [ ] **Plan dated yesterday** - Can create (historical entry)
- [ ] **Plan dated 5 years ago** - Date picker min boundary works
- [ ] **Plan dated 5 years future** - Date picker max boundary works
- [ ] **Plan dated 100 years future** - Rejected or capped
- [ ] **Leap year dates** - Feb 29 handled correctly
- [ ] **Timezone edge cases** - Dates consistent across timezone changes

### 5.5 Concurrent Operations
- [ ] **Create 2 plans rapidly** - Both created without conflict
- [ ] **Edit while creating** - Queue handled or prevented
- [ ] **Delete while editing** - Proper error handling
- [ ] **Sync while offline** - Queued for later

---

## 6. UI/UX QUALITY

### 6.1 Responsiveness
- [ ] **Portrait orientation** - Layout correct
- [ ] **Landscape orientation** - Layout adapts
- [ ] **Rotate device** - Rotation handled, data persists
- [ ] **Large text enabled** - Readability maintained
- [ ] **Small screen (phone)** - No unnecessary scrolling
- [ ] **Large screen (tablet)** - Proper use of space

### 6.2 Loading & Animations
- [ ] **Initial load** - Shows loading spinner
- [ ] **Pull-to-refresh** - Refresh indication shown
- [ ] **Button states** - Loading, disabled, enabled states clear
- [ ] **Smooth transitions** - No jarring screen changes
- [ ] **Animations complete** - No frozen UI

### 6.3 Visual Consistency
- [ ] **Color scheme** - Income (green), expense (red), primary (blue)
- [ ] **Icons clear** - All icons recognizable
- [ ] **Font sizes** - Hierarchy clear (headings > body > hints)
- [ ] **Spacing** - Consistent padding/margins
- [ ] **Dark mode** - If applicable, colors readable

### 6.4 Error Messages
- [ ] **Network error** - Clear, user-friendly message
- [ ] **Validation error** - Specific field highlighted
- [ ] **Calendar sync error** - Message explains issue
- [ ] **Not found (user)** - Clear "User not found" message
- [ ] **Insufficient balance** - Shows current balance
- [ ] **No actionable error** - Avoid technical jargon

### 6.5 Feedback & Confirmation
- [ ] **Success snackbars** - Clear confirmation displayed
- [ ] **Delete confirmations** - Data shown before deletion
- [ ] **Toast notifications** - Auto-dismiss appropriately
- [ ] **No silent failures** - All actions get feedback

---

## 7. SECURITY & DATA INTEGRITY

### 7.1 Authentication
- [ ] **Login required** - Cannot access app without auth
- [ ] **Session persistence** - Stay logged in on app restart
- [ ] **Logout clears data** - No residual user data visible
- [ ] **Token expiry handling** - Auto re-login on expired token

### 7.2 User Data Privacy
- [ ] **Only own data shown** - Cannot see other user's plans
- [ ] **Only own transfers shown** - Cannot see other user's transfers
- [ ] **User search safe** - Can search users but cannot see private data
- [ ] **Amounts visible only to owner** - Transfer recipient doesn't see amount until accepting

### 7.3 Input Validation
- [ ] **SQL injection** - Special characters handled safely
- [ ] **XSS prevention** - No script execution in text fields
- [ ] **File upload** - If applicable, validate file type
- [ ] **Amount overflow** - Large numbers handled safely

---

## 8. PERFORMANCE

### 8.1 Load Times
- [ ] **App startup** - < 3 seconds to main screen
- [ ] **Plan list load** - < 1 second initial load
- [ ] **Calendar view load** - < 1.5 seconds
- [ ] **Search users** - Results in < 2 seconds
- [ ] **Transfer submit** - Processing visible, completes in < 5 seconds

### 8.2 Memory Usage
- [ ] **No memory leak on navigation** - App responsive after multiple screens
- [ ] **No memory leak on list scroll** - Smooth scrolling 50+ items
- [ ] **Large images handled** - Camera photos compressed appropriately

### 8.3 Battery/Network
- [ ] **No excessive network calls** - Only necessary API calls made
- [ ] **Background sync minimal** - Battery drain minimal
- [ ] **Image compression** - Photos optimized before upload

---

## 9. REGRESSION TESTING

### 9.1 Previous Functionality
- [ ] **Budget feature works** - Can create/edit/delete budgets
- [ ] **Budget pie chart** - Displays correctly
- [ ] **Income tracking** - Records correctly
- [ ] **Expense tracking** - Records correctly
- [ ] **Pay later feature** - Works as before
- [ ] **Profile screen** - Loads user data correctly
- [ ] **Settings** - All toggles functional

---

## 10. SIGN-OFF

### Overall Status
- **Critical Issues Found:** _____
- **Minor Issues Found:** _____
- **Blockers for Release:** [ ] Yes [ ] No

### Sign-Off
- **Tested By:** _______________
- **Date:** _______________
- **Approved for Release:** [ ] Yes [ ] No
- **Release Notes:** 

```
- CRUD Expense Planner with device calendar sync (strict mode)
- Transfer to users, bank accounts, and QRIS payment support
- Pay Later management with reminders
- Calendar view with edit/delete capabilities
- Auto-refresh on mutations
- Comprehensive error handling
```

---

**Note:** This checklist covers happy paths and critical edge cases.  
For any issues found, document with:
- Steps to reproduce
- Expected behavior
- Actual behavior
- Device/OS version
- Screenshots if applicable

Test environment should have:
- Fresh user account (no prior history)
- Various data states (empty, single, multiple items)
- Different network conditions (WiFi, 4G, offline)
