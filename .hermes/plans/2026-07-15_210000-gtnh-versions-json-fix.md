# GTNH versions.json Downloader Fix Implementation Plan

> **For Hermes:** Use the checked-in task list to coordinate parallel implementation and review agents. Do not merge agent changes without running the validation gates below.

**Goal:** Make the GTNH deployment path reliably resolve, validate, download, and install stable, beta, RC, and explicitly pinned GTNH server packs from `https://downloads.gtnewhorizons.com/versions.json`.

**Architecture:** Keep the feature in the existing Bash deployment flow at `scripts/start-deployGTNH`. Normalize the selected release to one JSON shape, select the server URL using the container Java runtime, and preserve the existing `mc-image-helper` download/cache/extract/update pipeline. Add focused shell-level tests using local fixtures and stubbed commands so selection logic is deterministic and does not depend on the live GTNH service.

**Tech Stack:** Bash, `jq`, `curl`, `mc-image-helper`, existing Docker image test harness, Markdown documentation.

---

## Current findings and constraints

- The fork is `WowSuchRicky/docker-minecraft-server`, based on upstream `master`.
- The current upstream branch already contains a partial `versions.json` migration in `scripts/start-deployGTNH` (`32b026d0 Fix GTNH versions.json parsing (#4146)`).
- The current script has inconsistent JSON shapes: `latest`/`latest-dev` retain `{key,value}`, while explicit versions use only the value object, yet later code reads `.value.server...`. This must be made uniform.
- `latest-dev` currently filters only `title == "Beta release"`; the intended behavior must include beta and RC releases.
- The live GTNH service currently exposes beta `2.9.0-beta-2` with a Java 17–25 server URL. The implementation must not hard-code that version.
- Do not regress stable `latest`, explicit version selection, Java 8 selection, Java 17+ selection, existing `.gtnh-version` caching, config backups, or `SKIP_GTNH_UPDATE_CHECK`.
- Do not put live external pack archives into the repository.

## Coordination model

Work in separate branches/worktrees and integrate in this order:

1. **Discovery/research agent:** inspect upstream history and identify the smallest compatible change surface.
2. **Core implementation agent:** implement release parsing/selection and download URL validation.
3. **Test agent:** add deterministic fixtures/stubs and regression tests for selection behavior.
4. **Documentation/integration agent:** update GTNH documentation and examples, and review compatibility.
5. **Independent review agent:** inspect the combined diff for correctness, shell safety, upgrade behavior, and regressions.

Agents must report exact files changed, commands run, and test output. No agent may rewrite another agent's unrelated changes.

---

## Task 1: Baseline and implementation contract

**Objective:** Record the current behavior and define the observable contract before editing production code.

**Files:**
- Read: `scripts/start-deployGTNH`
- Read: `docs/types-and-platforms/mod-platforms/gtnh.md`
- Read: `examples/gtnh/docker-compose-type-gtnh.yaml`
- Create: `tests/gtnh-versions-json/README.md` if the test harness needs a dedicated fixture area.

**Required contract:**

- `GTNH_PACK_VERSION=latest` selects the newest stable release.
- `GTNH_PACK_VERSION=latest-dev` selects the newest beta or RC release.
- An exact version selects that version only.
- Selection is based on release metadata, not a directory listing.
- Java 8 selects `.server.java8Url`.
- Java 17+ selects `.server.java17_2XUrl` and rejects versions whose `maxJavaVersion` is lower than the runtime.
- Unsupported Java versions fail with a clear error.
- Missing release, missing server URL, malformed metadata, failed HTTP retrieval, and invalid selected URL all fail before attempting extraction.
- The selected version and URL are logged without exposing credentials or unrelated environment values.

**Verification:** Capture baseline test command(s) and current failure/success behavior before implementation.

---

## Task 2: Normalize versions.json parsing

**Objective:** Make every selection path return the same release object shape.

**Files:**
- Modify: `scripts/start-deployGTNH`
- Test: `tests/gtnh-versions-json/` or the repository's existing GTNH test location.

**Implementation requirements:**

- Fetch `versions.json` once per startup path and fail closed if `curl -fsSL` fails.
- Support the observed top-level forms `{"versions": {...}}` and a direct version map (`(.versions // .)`).
- For `latest`, filter `title == "Stable release"`.
- For `latest-dev`, filter `title == "Beta release"` or `title == "RC release"` (also tolerate a clearly documented case-insensitive equivalent if the source uses one).
- For an explicit version, match the object key exactly after the existing input normalization rules.
- Return a normalized object containing at least `version`, `releaseDate`, `title`, `maxJavaVersion`, and `server`.
- Use `jq -e`/explicit null checks so an empty selection cannot silently become the JSON literal `null`.
- Use a deterministic ordering: parse ISO-like release dates chronologically, then use the version key as a stable tie-breaker.
- Preserve whitespace-safe handling of `GTNH_PACK_VERSION`.

**Verification:** Unit-level shell tests must exercise all three selection modes and assert the normalized version and server URL.

---

## Task 3: Java compatibility and URL validation

**Objective:** Select the correct server archive and reject unusable metadata before download.

**Files:**
- Modify: `scripts/start-deployGTNH`
- Test: `tests/gtnh-versions-json/`

**Implementation requirements:**

- Read `mc-image-helper java-release` once.
- Java 8: require a non-empty `.server.java8Url`.
- Java >=17: require a numeric `maxJavaVersion`, reject runtimes above it, and require `.server.java17_2XUrl`.
- Java 9–16 and unsupported values: fail with the existing clear unsupported-runtime style.
- Reject `null`, empty, non-HTTPS, or malformed selected URLs.
- Keep the URL in a variable used by the existing `mc-image-helper get` call; do not interpolate untrusted metadata into shell syntax.
- Do not perform a full multi-hundred-megabyte pack download during unit tests. Stub `mc-image-helper`, `curl`, or the metadata-fetch helper.

**Verification:** Tests cover Java 8, Java 17, Java 25, Java too new, missing Java 8 URL, missing Java 17+ URL, and invalid URL metadata.

---

## Task 4: Download and cache safety

**Objective:** Ensure a selected release cannot corrupt an existing installation when the archive is unavailable or invalid.

**Files:**
- Modify: `scripts/start-deployGTNH` only if required; otherwise document that existing `mc-image-helper get` semantics are retained.
- Test: Existing GTNH test fixtures plus focused regression tests.

**Implementation requirements:**

- Preserve `/data/.gtnh-version` comparison behavior.
- Preserve `--skip-up-to-date` behavior from `mc-image-helper get`.
- Ensure a failed metadata lookup or download exits before deleting current server resources.
- Ensure failed extraction does not update `.gtnh-version` or remove a known-good installation.
- Verify the selected archive basename remains the cache/version identity used by the current update path.

**Verification:** Add or run a failure-path test proving an existing installation remains present after metadata/download failure.

---

## Task 5: Documentation and examples

**Objective:** Align user-facing GTNH documentation with the corrected behavior.

**Files:**
- Modify: `docs/types-and-platforms/mod-platforms/gtnh.md`
- Modify: `examples/gtnh/docker-compose-type-gtnh.yaml` only if comments or values are stale.
- Do not modify homelab deployment files in this repository.

**Documentation requirements:**

- Explain `latest` versus `latest-dev`.
- State that `latest-dev` includes beta and RC releases.
- Explain Java 8 versus Java 17+ server archive selection.
- Explain exact version pinning and `SKIP_GTNH_UPDATE_CHECK`.
- Document clear failure behavior when GTNH metadata or compatible server URLs are unavailable.
- Keep the documented Java argument behavior accurate for Java 17+ and Java 8.

**Verification:** Build or run the repository documentation checks used by CI.

---

## Task 6: Regression and integration validation

**Objective:** Prove the fix works without relying solely on a live external service.

**Files:**
- Test files created/modified by Tasks 2–4.
- CI configuration only if a focused test job is required and consistent with repository conventions.

**Required checks:**

```bash
bash -n scripts/start-deployGTNH
shellcheck scripts/start-deployGTNH
# Run the focused GTNH/version tests
# Run the repository test harness used by CI
bash tests/test.sh
```

Also verify:

- Stable `latest` selection.
- Beta/RC `latest-dev` selection.
- Exact `2.9.0-beta-2` selection from a fixture.
- Java 8 and Java 17+ URL selection.
- Explicit unsupported-version and malformed-metadata failures.
- No changes to unrelated mod-platform deployment scripts.

If Docker-based integration tests are available and practical, run a test using a tiny fixture archive or a mocked metadata/download endpoint. Do not make CI depend on the live GTNH archive service for every test.

---

## Task 7: Independent review and hardening

**Objective:** Review the combined change before publishing it from the fork.

**Review focus:**

- Bash quoting, `set -e` behavior, pipeline failure propagation, and `jq` exit status.
- JSON shape consistency across all selection modes.
- Beta/RC semantics and semantic/date ordering.
- Java compatibility behavior.
- URL validation and SSRF/security implications.
- Preservation of existing installation/update/backup behavior.
- Test determinism and absence of large binary fixtures.
- Documentation accuracy.

**Required output:** A structured review listing blocking issues, non-blocking suggestions, and a pass/fail verdict. Fix blocking issues, rerun all validation, and obtain a second review if the implementation changes materially.

---

## Task 8: Fork branch, PR, and downstream rollout

**Objective:** Publish the corrected implementation from the fork and prepare the homelab to consume it.

**Files:**
- Repository source and tests from Tasks 2–7.
- Downstream homelab repository only in a separate follow-up MR after an image is built and verified.

**Steps:**

1. Commit focused changes with conventional messages.
2. Push `feat/gtnh-versions-json` to `WowSuchRicky/docker-minecraft-server`.
3. Run GitHub Actions and inspect failures; do not claim success from a queued workflow.
4. Open a PR from the fork to `itzg/docker-minecraft-server` with reproduction, root cause, tests, and compatibility notes.
5. Build a fork image only if the project workflow supports it; record the immutable digest.
6. Create a separate homelab MR that switches only GTNH beta from the temporary custom-pack workaround back to native `TYPE=GTNH` plus `GTNH_PACK_VERSION=latest-dev` using the fork image digest.
7. Merge/reconcile in GitOps order and verify the beta pod, restart count, selected pack version, and server readiness.

**Do not:** push to upstream `master`, publish mutable-only image references for production testing, or remove the homelab workaround before the replacement image has passed a real startup test.

---

## Acceptance criteria

- Native `TYPE=GTNH` with `GTNH_PACK_VERSION=latest-dev` selects a beta or RC server pack from `versions.json` and no longer exits with “Server files not found”.
- Stable and exact-version behavior remains compatible.
- Java 8 and Java 17+ archive selection is correct and guarded by compatibility metadata.
- Focused tests and the repository test suite pass.
- Documentation explains the supported version-selection behavior.
- A GitHub PR is opened from the fork with reproducible evidence.
- The homelab beta workload is not switched back until an immutable fixed image has been verified.
