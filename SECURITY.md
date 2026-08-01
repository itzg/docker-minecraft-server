# Security Policy

## Supported Versions

Only the latest release or `latest` Docker tag receives security updates. If you discover a vulnerability, please test against the latest image version before reporting.

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.**

To report a vulnerability privately:

1. Navigate to the **[Security](https://github.com/itzg/docker-minecraft-server/security)** tab of this repository.
2. Select **Report a vulnerability** to open a private security advisory.

This allows us to review, reproduce, and resolve the issue in a private environment before public disclosure.

---

## Important Expectations & Bug Bounties

* **No Financial Bounties:** This is an open-source, community-maintained project. We **do not** offer financial rewards, gift cards, or monetary bounties for vulnerability reports.
* **Non-Critical & Automated Findings:** Reports generated purely by automated scanners (such as generic HTTP headers, low-severity container base image updates, or standard configuration warnings) without a working, practical proof-of-concept specific to this container will generally be closed.

---

## Dependency Upgrades & Pull Requests

We welcome and appreciate community contributions! 

If you identify an outdated or vulnerable upstream dependency (such as base packages, utilities, or underlying binaries), **we strongly encourage you to submit a Pull Request directly**. 

Community-contributed PRs targeting dependency patches are the fastest way to get updates validated, built, and merged into the main release.
