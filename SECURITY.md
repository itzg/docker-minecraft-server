# Security Policy

## Supported Versions

Only the latest release or `latest` Docker tag receives security updates. If you discover a vulnerability, please test against the latest image version before reporting.

## Automated Scans & Base Image Dependency Updates

- **Automated Dependency Updates:** This repository utilizes automated background workflows to continuously upgrade base images, underlying dependencies, and the Go toolchain. Because CVE scanning tools flag vulnerabilities as soon as they are logged it is not practical to address them any faster than the automation is doing.
- **Image Scan Reports & Triaging:** Please refrain from submitting raw scanner reports or screenshots (e.g., outputs from Trivy, Grype, or Docker Scout). CVEs in upstream base packages or system libraries are often constrained by upstream package maintainers. Submitting an issue or advisory for a scanner report does not accelerate a fix if the patch is not yet available in the upstream base image.
- **Actionable PRs Welcome:** If a fix or patched package version **is** available upstream and has not yet been picked up by our automated build pipelines, submitting a pull request that updates the specific version pin or dependency is the best way to help speed up integration.

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
