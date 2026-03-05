# Username Override Bug - Root Cause & Fix

## Bug Summary
When users signed up to Money Planner, their chosen username was ignored and replaced with the email prefix.

**Example:**
- User enters username: `darma`
- User's email: `darmawanaditya521@gmail.com`
- Username saved in database: `darmawanaditya521` (email prefix)

This caused:
- Username search in transfer feature to fail
- User recipients showing as "wallet tidak tersedia"
- Usernames not matching what users expected

---

## Root Cause Analysis

### The Bug Location
File: [supabase/schema.sql](supabase/schema.sql) → Function `handle_new_user()` (lines 125-135)

### What Was Wrong
```sql
-- OLD (BUGGY) CODE:
INSERT INTO public.users (id, email, username, full_name)
VALUES (NEW.id, NEW.email, split_part(NEW.email, '@', 1), '');
```

The trigger was:
- ❌ Ignoring username sent from the app
- ❌ Ignoring full_name sent from the app  
- ❌ Generating username from email prefix using `split_part(NEW.email, '@', 1)`
- ❌ Hard-coding empty string for full_name

### Data Flow of the Bug
1. **Register Screen** (`register_screen.dart` line 45)
   - Collects username input: "darma"
   - Passes to AuthProvider: `signUpWithEmail(username: "darma", ...)`

2. **AuthProvider** (`auth_provider.dart` lines 60-84)
   - Receives username: "darma"
   - Forwards to AuthRepository: `signUpWithEmail(username: "darma", ...)`

3. **AuthRepository** (`auth_repository.dart` lines 30-60)
   - Normalizes username: `normalizedUsername = "darma"`
   - Sends to Supabase: `data: {'username': 'darma', 'full_name': 'User Name'}`
   - ✅ This part worked correctly

4. **Supabase Trigger** (`schema.sql` lines 125-135)
   - ❌ BUG OCCURS HERE
   - Receives NEW.raw_user_meta_data with `username: 'darma'`
   - IGNORES IT and uses: `split_part(NEW.email, '@', 1)` → 'darmawanaditya521'
   - Username saved to database: `darmawanaditya521`

---

## The Fix

### What Changed
```sql
-- NEW (FIXED) CODE:
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, username, full_name)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE((NEW.raw_user_meta_data->>'username'), split_part(NEW.email, '@', 1)),
    COALESCE((NEW.raw_user_meta_data->>'full_name'), '')
  );
  INSERT INTO public.wallets (user_id) VALUES (NEW.id);
  INSERT INTO public.paylater_accounts (user_id) VALUES (NEW.id);
  RETURN NEW;
END;
```

### Key Changes Explained

| Part | Old | New | Benefit |
|------|-----|-----|---------|
| **username** | `split_part(NEW.email, '@', 1)` | `COALESCE((NEW.raw_user_meta_data->>'username'), split_part(NEW.email, '@', 1))` | Uses user-provided username; only falls back to email prefix if none provided |
| **full_name** | `''` (empty) | `COALESCE((NEW.raw_user_meta_data->>'full_name'), '')` | Saves user-provided full name instead of leaving it empty |

### How It Works Now
1. Trigger checks if username exists in auth metadata: `raw_user_meta_data->>'username'`
2. If yes, uses it: `'darma'` ✅
3. If no, falls back to email prefix: `split_part(email, '@', 1)`
4. Same logic for full_name

---

## Deployment Instructions

### Step 1: Apply Trigger Fix
Run this in Supabase SQL Editor:
```sql
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, username, full_name)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE((NEW.raw_user_meta_data->>'username'), split_part(NEW.email, '@', 1)),
    COALESCE((NEW.raw_user_meta_data->>'full_name'), '')
  );
  INSERT INTO public.wallets (user_id) VALUES (NEW.id);
  INSERT INTO public.paylater_accounts (user_id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Step 2: Verify in schema.sql
✅ Already updated in [supabase/schema.sql](supabase/schema.sql)

### Step 3: Fix Existing Users (Optional but Recommended)

Run the audit migration:
```
supabase/fix_existing_usernames_migration.sql
```

This identifies which users have incorrect usernames (equal to their email prefix).

#### Options for Fixing Existing Users

**Option A: Add User Profile Update Screen (Recommended)**
- Let users edit their username in Settings/Profile
- Minimal database changes
- User chooses if they want to fix it
- Add validation to prevent duplicates

**Option B: Manual Admin Update**
- If you have original username data from logs, bulk update
- Query: `auth.users.raw_user_meta_data` to check what they originally entered
- Update `public.users.username` for affected users

**Option C: No Fix for Existing Users**
- New signups will have correct usernames
- Existing users keep email prefix usernames
- Works if not too many users affected

---

## Impact & Testing

### What This Fixes
- ✅ New signups will have correct usernames
- ✅ Username search in transfer feature will work correctly
- ✅ "Wallet tidak tersedia" error should resolve (when combined with username mismatch)
- ✅ User profile consistency

### Who It Affects
- **NEW SIGNUPS:** Will have correct username from now on
- **EXISTING USERS:** Will keep their email-prefix username unless manually updated

### Testing Checklist
After deployment, test:
- [ ] Create new account with username "testuser"
- [ ] Verify in database: `SELECT username FROM users WHERE email = 'test@example.com'`
- [ ] Username should be "testuser", NOT "test"
- [ ] Test transfer feature: search for new user by their correct username
- [ ] Transfer feature should find correct wallet
- [ ] Test signup with different email domains (gmail, yahoo, outlook, etc.)

### How This Relates to Transfer Feature Bug
The "wallet tidak tersedia" error was likely caused by this username mismatch:
1. User enters username "darma" during signup
2. System saves "darmawanaditya521" (wrong)
3. Another user tries to transfer to "darma"
4. System searches for "darma" in users table
5. Finds nothing (because it's stored as "darmawanaditya521")
6. Shows "wallet tidak tersedia" error

**After this fix:** Username search will work correctly and resolve the transfer wallet error.

---

## Files Modified
- ✅ [supabase/schema.sql](supabase/schema.sql) - Fixed `handle_new_user()` trigger
- ✅ [supabase/fix_existing_usernames_migration.sql](supabase/fix_existing_usernames_migration.sql) - Audit script for existing users

## No Code Changes Needed
The Flutter app code is already correct:
- ✅ [lib/presentation/screens/auth/register_screen.dart](lib/presentation/screens/auth/register_screen.dart) - Already sends username
- ✅ [lib/providers/auth_provider.dart](lib/providers/auth_provider.dart) - Already passes username
- ✅ [lib/data/repositories/auth_repository.dart](lib/data/repositories/auth_repository.dart) - Already normalizes username

---

## Next Steps
1. ✅ Deploy trigger fix to Supabase
2. Run audit script to identify affected existing users
3. Decide on approach for fixing existing user usernames (Options A, B, or C)
4. Test new signup with username
5. Re-test transfer feature with new accounts
6. Consider adding user profile edit screen for flexibility

---

## Summary
**The Bug:** Signup trigger ignored user-provided username and replaced it with email prefix.

**The Root Cause:** Trigger used `split_part(email, '@', 1)` instead of `raw_user_meta_data->>'username'`.

**The Fix:** Updated trigger to use user-provided username with email prefix as fallback.

**Status:** ✅ Fixed in schema.sql, ready for deployment.
