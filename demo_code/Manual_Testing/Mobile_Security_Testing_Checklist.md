# Mobile Security Testing Checklist

This checklist was developed and applied during mobile security testing of **Freenance**, a personal finance management app. The goal was to ensure proper handling of sensitive financial data, secure communication, and robust session control.

---

##  Purpose

To verify the mobile application complies with key mobile security standards, particularly focusing on the safe storage, transmission, and processing of user data.

---

## ✅ Checklist

### 1. Data Storage

- [x] Reviewed local data storage mechanisms (SharedPreferences, Keychain, SQLite, files)
- [x] Verified encryption of sensitive data (tokens, passwords, API keys)
- [x] Ensured no sensitive data is stored on external storage (e.g., SD card)
- [x] Confirmed logs do not expose confidential data
- [x] Verified that data is cleared upon user logout or app uninstall

---

### 2. Data Transmission

- [x] Confirmed all communication is performed over HTTPS
- [x] Analyzed network traffic using Charles Proxy and Burp Suite
- [x] Validated proper SSL certificate verification and SSL pinning
- [x] Attempted man-in-the-middle (MITM) attacks — app correctly resisted them
- [x] Checked that sensitive data is not passed via URLs or HTTP headers

---

### 3. Authentication & Session Management

- [x] Enforced strong password policy with complexity rules
- [x] Tested secure password recovery mechanisms
- [x] Verified that session is terminated upon logout
- [x] Checked session expiration and prevention of session reuse
- [x] Validated response to failed login attempts and lockout logic

---

### 4. Code Protection & Reverse Engineering

- [x] Confirmed usage of code obfuscation (ProGuard / R8 for Android)
- [x] Decompiled APK with jadx/apktool — no hardcoded secrets found
- [x] Verified absence of hardcoded credentials or tokens
- [x] Checked for debug mode disablement in release builds
- [x] Tested app’s resistance to code injection or runtime manipulation

---

### 5. Permissions & Access Control

- [x] Ensured app requests only necessary permissions
- [x] Verified graceful handling when permissions are denied
- [x] Tested permission behavior across various Android/iOS versions
- [x] Checked for permission escalation or bypass vectors

---

### 6. Interaction with OS & Other Apps

- [x] Prevented installation from untrusted sources in production
- [x] Verified no sensitive data is shared with external apps without encryption
- [x] Checked for Intent Spoofing vulnerabilities
- [x] Ensured that app data is not accessible via other apps

---

### 7. Error Handling & Logging

- [x] Reviewed logs for sensitive data exposure
- [x] Verified that error messages do not leak technical or internal app info
- [x] Checked for stack traces or debug output in production builds

---

### 8. API Security

- [x] Tested authentication and authorization for API endpoints
- [x] Verified that unauthorized users cannot access protected API routes
- [x] Checked protection mechanisms against brute force and rate-limiting attacks

---

### 9. General Recommendations

- [x] Followed [OWASP Mobile Security Testing Guide (MSTG)](https://owasp.org/www-project-mobile-security-testing-guide/)
- [x] Ensured SDKs and libraries are up-to-date
- [x] Recommended integrating security tests into CI/CD pipeline
- [x] Documented all vulnerabilities and proposed remediation strategies

---

## Tools Used

- Charles Proxy  
- Burp Suite  
- Frida (runtime instrumentation)  
- adb + logcat  
- jadx / apktool  
- OWASP MSTG Checklist  

---

## 🗒 Findings Example

> During static analysis, a debug log was found storing access tokens in plaintext.  
> ✅ Reported and resolved by removing the log and using encrypted token storage.
> In addition, the team implemented an expiration policy for access tokens to minimize the risk of token theft or reuse.  
> ✅ Token lifetime was limited, and automatic invalidation after inactivity was introduced.

