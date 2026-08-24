# Exact review label reconciliation proof

## Claim

Exact publication of a completed, current-head pull request review reconciles stale managed status
and rating labels after the command that requested the review. Human activity after the completed
review still blocks reconciliation.

## Exercised surface

- The built `dist/clawsweeper.js apply-decisions` command
- Exact-event publication with a current report-owned review lease
- Full pull request context hydration through a local GitHub CLI transport
- Batched managed-label additions and removals
- Durable review comment publication and lease cleanup

## Controlled scenario

The fixture starts with `status: 📣 needs proof` and `rating: 🦪 silver shellfish`. A
command requests a re-review, and the completed report for the unchanged 40-character head selects
`proof: sufficient`, `rating: 🦞 diamond lobster`, and `status: 👀 ready for maintainer look`.
The built apply command runs in exact-publication mode against a local GitHub CLI transport and
emits the normalized mutation it would send to GitHub. The adjacent scenario supplies human
activity after `reviewed_at` and asserts that no label edit occurs.

## Command and environment

Run from the repository root with Node 24 or newer and frozen dependencies installed:

```bash
bash docs/proof/exact-review-label-reconciliation/run-proof.sh
```

## Required observations

- The exact-publication scenario emits one `issue edit` mutation.
- The mutation adds the current proof, rating, status, and merge-risk labels.
- The mutation removes both stale status and rating labels.
- The durable review comment is patched.
- The later-human-activity scenario passes without a label mutation.

## Limits and Bay impact

The GitHub CLI transport is local and deterministic; no live repository, comment, label, lease, or
workflow is contacted or mutated. The proof covers the shipped apply workflow, context hydration,
freshness guards, exact review lease, batched label mutation, and durable-comment path. It does not
exercise GitHub's hosted API implementation.

OpenClaw Bay is unaffected. This changes GitHub managed-label reconciliation only and does not
change Bay data, routes, observer contracts, or controls.
