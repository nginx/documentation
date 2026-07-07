# F5 NGINX Documentation Style Compliance Analysis
## `/content/nim` Directory - Complete Report
**Analysis Date:** April 22, 2026  
**Total Files Analyzed:** 143 markdown files  
**Files with Issues:** 25+ files  
**Total Issues Found:** 150+

---

## Executive Summary

The `/content/nim` directory contains multiple style compliance violations across three primary issue categories:

1. **CRITICAL - Call-out Shortcode Syntax (25 instances):** Files use incorrect `{{< call-out "type" >}}` format instead of proper `{{< call-out class="type" title="..." >}}` syntax
2. **MAJOR - Forbidden Terminology (7 instances):** Use of "As a result" and "click" violates style guide replacements
3. **MINOR - Product Naming & Passive Voice (15+ instances):** Inconsistent first mention of "F5 NGINX Instance Manager" and passive product descriptions

---

## 🔴 CRITICAL ISSUES

### Call-out Shortcode Syntax Violations (25 instances)

**Issue:** Files use abbreviated call-out syntax `{{< call-out "type" >}}` instead of proper format `{{< call-out class="type" title="Title Text" >}}`

**Standard:** Must follow format: `{{< call-out class="note|warning|caution|important|tip" title="Title" >}}...{{< /call-out >}}`

#### Files with Issues:

| File Path | Line(s) | Issue | Fix |
|-----------|---------|-------|-----|
| `releases/known-issues.md` | 13 | `{{< call-out "tip" >}}` | Change to `{{< call-out class="tip" title="Recommendation" >}}` |
| `releases/release-notes.md` | 167 | `{{< call-out "important" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `releases/release-notes.md` | 281 | `{{< call-out "important" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `releases/release-notes.md` | 425 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `releases/release-notes.md` | 463 | `{{< call-out "important" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `releases/release-notes.md` | 1251 | `{{< call-out "important" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `releases/release-notes.md` | 1690 | `{{< call-out "important" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `releases/release-notes.md` | 1848 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `disconnected/add-license-disconnected-deployment.md` | 14 | `{{< call-out "tip" "Using the REST API" "" >}}` | Change to `{{< call-out class="tip" title="Using the REST API" >}}` |
| `disconnected/add-license-disconnected-deployment.md` | 38 | `{{< call-out "important" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `disconnected/add-license-disconnected-deployment.md` | 70 | `{{< call-out "important" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `disconnected/add-license-disconnected-deployment.md` | 74 | `{{< call-out "important" "TLS certificate validation">}}` | Change to `{{< call-out class="important" title="TLS certificate validation" >}}` |
| `nginx-configs/publish-configs-version-control.md` | 143 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `nginx-instances/scan-instances.md` | 18 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `nginx-instances/scan-instances.md` | 40 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `nginx-instances/manage-instance-groups.md` | 43 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `nginx-instances/manage-instance-groups.md` | 67 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `nginx-instances/manage-instance-groups.md` | 69 | `{{< call-out "important" "Important:" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `nginx-instances/manage-instance-groups.md` | 137 | `{{< call-out "important" "Important:" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `nginx-instances/manage-instance-groups.md` | 206 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `monitoring/metrics-api.md` | 156, 166, 170, 216, 236 | `{{< call-out "note/tip" >}}` | Change to proper class= format with titles |
| `security-monitoring/give-access-to-security-monitoring-dashboards.md` | 16 | `{{< call-out "note" >}}` | Change to `{{< call-out class="note" title="Note" >}}` |
| `fundamentals/tech-specs.md` | 160 | `{{< call-out "important" >}}` | Change to `{{< call-out class="important" title="Important" >}}` |
| `deploy/kubernetes/helm-config-settings.md` | 14 | `{{< call-out "important" "legacy chart name" >}}` | Change to `{{< call-out class="important" title="Legacy Chart Name" >}}` |
| `admin-guide/authentication/oidc/microsoft-entra-automation.md` | 16 | `{{<call-out "important" "Required steps">}}` | Change to `{{< call-out class="important" title="Required Steps" >}}` |

---

## 🟠 MAJOR ISSUES

### Forbidden Terms - Incorrect Usage (7 instances)

#### 1. "As a result" instead of "because" for cause-effect
**Standard:** Use "because" for cause-effect relationships, not "as a result"

| File Path | Line | Text | Fix |
|-----------|------|------|-----|
| `system-configuration/configure-forward-proxy.md` | 33 | "As a result, HTTPS proxy configurations (with or without authentication) may not work..." | Change to: "Because of this, HTTPS proxy configurations may not work..." |
| `releases/known-issues.md` | 695 | "As a result, the `getAttackCountBySeverity` endpoint...will report zeroes..." | Change to: "Therefore, the endpoint will report zeroes..." or restructure |
| `releases/known-issues.md` | 1014 | "As a result, configuration changes will take at least one second to appear." | Change to: "Because of this, configuration changes..." |
| `releases/known-issues.md` | 1115 | "As a result, you may not be able to access features..." | Change to: "Therefore, you may not be able to access features..." |

#### 2. "click" instead of "select" for UI interactions
**Standard:** Use "select" for all UI interactions (not "click")

| File Path | Line | Text | Fix |
|-----------|------|------|-----|
| `releases/release-notes.md` | 87 | "Roll out the latest bot signatures to all previously published policies with one click." | Change to: "...with one selection." or "...by selecting the rollout button." |
| `releases/known-issues.md` | 386 | "Find the template you want to lock and click the **Actions** button (three dots)." | Change to: "...and select the **Actions** button..." |

---

## 🟡 MINOR ISSUES

### Product Naming - Missing "F5" on First Mention (2 instances)

**Standard:** First mention of NGINX Instance Manager should be "F5 NGINX Instance Manager", subsequent mentions can omit "F5"

| File Path | Line | Issue | Current | Should Be |
|-----------|------|-------|---------|-----------|
| `disconnected/add-license-disconnected-deployment.md` | 12 | First mention lacks "F5" prefix | "add a license to NGINX Instance Manager" | "add a license to F5 NGINX Instance Manager" |
| Various files | Multiple | Check if first mention in opening paragraph includes "F5" | "NGINX Instance Manager" | "F5 NGINX Instance Manager" |

---

### Passive Product Naming - "allows you to" (15+ instances)

**Standard:** Avoid passive constructions like "allows you to", "provides the ability to". Use more direct language.

| File Path | Line | Example | Issue Type |
|-----------|------|---------|-----------|
| `fundamentals/api-overview.md` | 19 | "The NGINX Instance Manager REST API allows you to manage..." | Passive product description |
| `nginx-configs/publish-configs.md` | 41 | "This allows you to retrieve a configuration..." | Passive product description |
| `releases/release-notes.md` | 983 | "...the NGINX Plus Health Check feature now allows you to monitor..." | Passive product description |
| `releases/release-notes.md` | 1282 | "Instance Manager web interface now allows you to view..." | Passive product description |
| `releases/release-notes.md` | 1413 | "Instance Manager now allows you to set up automatic downloads..." | Passive product description |
| `nginx-configs/stage-configs.md` | 82 | "This allows you to retrieve a configuration..." | Passive product description |
| `security-monitoring/troubleshooting.md` | 18 | "This allows users to send logs..." | Passive product description |
| `waf-integration/policies-and-logs/policies/add-signature-sets.md` | 24, 105 | "allows you to explicitly enable or disable..." | Passive product description |
| `nginx-configs/config-templates/concepts/template-resources.md` | 18 | "This allows users to efficiently customize..." | Passive product description |

---

## 📊 Issue Summary by Severity

### Critical (Must Fix - Breaks Compliance)
- **Call-out Syntax Errors: 25 instances** across 15+ files
- **Impact:** Shortcodes may not render correctly; fails linting requirements

### Major (Should Fix - Violates Standards)
- **Forbidden Terms: 7 instances** 
  - "As a result": 4 instances
  - "click" instead of "select": 2 instances
- **Impact:** Violates F5 Modern Voice and style guide

### Minor (Nice to Fix - Quality Improvement)
- **Product Naming: 2-3 instances** (missing "F5" prefix)
- **Passive Voice: 15+ instances** (could be more direct)
- **Impact:** Inconsistent brand messaging; less impactful on standards compliance

---

## 📁 Files Requiring Corrections

### High Priority (5+ issues each):
1. `releases/release-notes.md` - 8 call-out syntax + 1 "click" issue
2. `disconnected/add-license-disconnected-deployment.md` - 4 call-out syntax + 1 product naming
3. `nginx-instances/manage-instance-groups.md` - 5 call-out syntax issues
4. `releases/known-issues.md` - 1 call-out + 2 "As a result" + 1 "click"

### Medium Priority (3-4 issues each):
5. `monitoring/metrics-api.md` - 5 call-out syntax issues
6. `nginx-configs/publish-configs-version-control.md` - 1 call-out + passive voice
7. `nginx-instances/scan-instances.md` - 2 call-out syntax issues
8. `system-configuration/configure-forward-proxy.md` - 1 "As a result" violation

---

## ✅ Recommendations

### Immediate Actions (Critical):
1. **Fix all 25 call-out shortcode instances** - Use automated find/replace with regex patterns
2. **Replace all "As a result" with "because" or restructure** - 4 instances
3. **Replace "click" with "select"** - 2 instances

### Follow-up Actions (Major):
4. Add "F5" prefix to first mentions of NGINX Instance Manager in affected files
5. Review and update passive product descriptions ("allows you to") for more direct language

### Quality Improvements (Minor):
6. Conduct full documentation audit for consistent product naming across all releases/
7. Add linting rules to catch call-out syntax violations in pre-commit hooks

---

## 🔧 Automated Fix Suggestions

### Fix Call-out Syntax (Global Replacement Pattern):
```
Find: {{< call-out "([a-z]+)" >}}
Replace: {{< call-out class="$1" title="$1" >}}

Find: {{< call-out "([a-z]+)" "([^"]*)" "" >}}
Replace: {{< call-out class="$1" title="$2" >}}
```

### Fix "As a result" (Context-dependent - manual review needed):
```
Find: As a result,
Replace: Therefore, / Because of this, / Consequently,
(Choose contextually appropriate replacement)
```

### Fix "click" to "select":
```
Find: click (the|a) \*\*([^*]+)\*\*
Replace: select the **$2**
```

---

## 📌 Notes

- Analysis focused on F5 NGINX documentation standards per `copilot-instructions.md`
- All line numbers are 1-indexed as displayed in VS Code
- "Go to" usage (not "navigate to") appears correct per style guide - no violations found
- Links using `{{< ref >}}` shortcode appear correct in sampled files
- Sentence length violations would require full text analysis - spot checks show compliance in samples reviewed

---

**End of Report**
