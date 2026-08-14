# Security Policy

The Sia team and contributors take the security and privacy of our users seriously. As an AI assistant handling daily schedules, Google workspace integrations, and local databases, we are committed to maintaining the highest security and data privacy standards.

---

## Supported Versions

We provide security updates and bug fixes for the following versions of Sia:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0.0 | :x:                |

---

## Reporting a Vulnerability

If you discover a security vulnerability in Sia, please report it responsibly:

1. **Do NOT open a public GitHub issue** for sensitive vulnerabilities.
2. Report via **GitHub Private Vulnerability Reporting**:
   - Navigate to the [Security Advisories tab](https://github.com/sachinxrg/Sia/security/advisories/new) of the repository.
   - Click "Report a vulnerability".
3. Alternatively, reach out directly to the maintainer via GitHub profile contact.

### What to Include in Your Report

To help us triage and resolve the issue quickly, please provide:
- A clear description of the vulnerability.
- Proof-of-concept steps, script, or payload to reproduce the issue.
- Potential impact and attack scenarios.
- Any suggested remediations or patches.

### Response Timeline

- **Acknowledgment:** Within 48 hours of initial report.
- **Assessment & Triage:** Within 5 business days.
- **Fix & Public Release:** Coordinated disclosure after patch verification.

---

## Security Best Practices for Contributors

- **API Keys & Secrets:** Never hardcode or commit API keys (e.g., Gemini API keys, OAuth client secrets) into the source tree. Always use `.env` or secure environment variables.
- **Local Storage:** Keep local sensitive user data in secure storage or encrypted SQLite fields where applicable.
- **Dependencies:** Regularly audit third-party Flutter packages using `flutter pub outdated` and automated GitHub Dependabot scans.
