---
name: nuvora-sentinel
description: Build, review and debug identity, authentication and authorization on Nuvora Nexus Sentinel — the embeddable, code-first identity provider for .NET. Covers passkeys and MFA, refresh-token families, the service:scope:action permission grammar with RBAC + ABAC, the in-house OIDC server, SAML both directions, SCIM provisioning, multi-org and delegated admin, machine identity and workload federation, webhooks, tamper-evident audit, GDPR crypto-shredding, and migration from Keycloak/Auth0/ASP.NET Identity. Always reads current documentation from sentinel.nuvoralabs.com. Use whenever the work touches Nuvora.Nexus.Sentinel.* packages, AddSentinel, MapSentinelAuth, SentinelPrincipal, PermissionId, AuthorizationEvaluator, snt_ API keys, or when the user asks anything about Sentinel.
license: MIT
---

# Nuvora Nexus Sentinel

Sentinel is a batteries-included, embeddable, code-first identity provider for .NET.
It is simultaneously the identity store and token authority for your own apps, a
standards-compliant OAuth2/OIDC authorization server, a SAML IdP *and* SP, and a
SCIM 2.0 provisioning server — running inside your process, on your database.

This is security-critical code. Correctness matters more than speed here.

## Read the live docs before you write code

**Do not answer from memory and do not invent APIs.** Sentinel is pre-1.0 and its
surface is still settling. For any non-trivial question or code change, fetch the
relevant page first — every page is available as clean Markdown by appending `.md`
to its path.

```bash
scripts/fetch-docs.sh get docs/authorization articles/passkeys
scripts/fetch-docs.sh search refresh token rotation   # find pages by keyword
scripts/fetch-docs.sh security token-theft-and-reuse-detection
scripts/fetch-docs.sh index                           # the whole page index (llms.txt)
scripts/fetch-docs.sh api Nuvora.Nexus.Sentinel.OidcServer
```

The script caches for 6 hours under `$TMPDIR`. If it is unavailable, plain
`curl -sL https://sentinel.nuvoralabs.com/<path>.md` does the same job, and
`WebFetch` works too.

Routing rule:

1. **Concepts and "how does X work"** → `docs/<topic>.md` (the reference).
2. **"How do I actually build X"** → `articles/<slug>.md` (numbered, hands-on
   tutorials with samples at
   `github.com/nuvoralabs/sentinel-examples/tree/main/<NNN>-<slug>`).
3. **"Are we safe against X"** → `security/<attack-class>.md`. Each recipe states
   the threat, the Sentinel mechanism that counters it, **and what the host app must
   still do itself** — that last part is where real bugs live. Read the recipe
   whenever a change touches the attack surface it describes.
4. **Exact type, method or option names** → `api/nuvora-nexus-sentinel-<pkg>.md`.
5. **Nothing matches** → run `scripts/fetch-docs.sh index` and route from there.

Prefer targeted pages over `llms-full.txt` (~300 KB — last resort only).

## Where to look

| The task is about | Start here | Then |
|---|---|---|
| Wiring Sentinel into an app, first login | `docs/getting-started.md` | `articles/first-login.md` |
| Passwords, passkeys/WebAuthn, TOTP, email OTP, recovery codes, step-up, abuse protection | `docs/authentication.md` | `articles/passkeys.md`, `articles/abuse-protection-layers.md`, `articles/adaptive-risk-engine.md` |
| Permissions, grants, RBAC + ABAC, visibility, `can()` | `docs/authorization.md` | `articles/permission-grammar-and-evaluation.md` |
| Refresh tokens, sessions, reuse detection | `docs/authentication.md` | `articles/refresh-token-families.md` |
| Acting as an OIDC/OAuth2 provider | `docs/oidc-provider.md` | `articles/oidc-server-in-your-app.md` |
| SAML, external IdP federation, SCIM, multi-org, delegated admin | `docs/enterprise.md` | `articles/saml-both-directions.md`, `articles/scim-provisioning.md`, `articles/multi-org-and-delegated-admin.md` |
| Service accounts, `snt_` API keys, CI/CD without secrets | `docs/machine-identity.md` | `articles/workload-identity-federation.md`, `articles/api-keys-owner-capped.md` |
| Webhooks, audit ledger, impersonation, break-glass, admin console | `docs/operations.md` | `articles/webhooks-that-survive.md`, `articles/tamper-evident-audit.md`, `articles/break-glass-and-impersonation.md` |
| GDPR export/erasure, crypto-shredding, retention, localization | `docs/compliance.md` | `articles/gdpr-crypto-shredding.md` |
| Embedded vs Sentinel Server, YAML realm config, storage, the Relay bridge | `docs/deployment.md` | `articles/config-as-code.md`, `articles/relay-bridge.md` |
| Migrating off Keycloak / Auth0 / ASP.NET Identity / Duende | `docs/migration.md` | `articles/importing-identity.md`, `articles/shadow-mode-migration.md` |

`references/doc-map.md` has the complete page list, including all 20 articles, the
10 security recipes and the 10 API reference pages.

## Wiring, and the order that matters

```csharp
var builder = WebApplication.CreateBuilder(args);

// 1. Stores FIRST — registrations are TryAdd-idempotent, so whoever claims a port wins.
builder.Services.AddSentinelEfCoreStores(o => o.UseNpgsql(connectionString));

// 2. The engine: login, tokens, snapshots, risk, abuse, audit.
builder.Services.AddSentinel();

// 3. HTTP: the authentication handler and endpoint plumbing.
builder.Services.AddSentinelAuthentication(o =>
{
    o.Issuer         = "https://id.example.com";
    o.Audience       = "example-api";      // empty Audience is refused, by design
    o.DefaultRealmId = realmId;
    o.Transport      = SentinelTokenTransport.BearerAndCookie;
});

var app = builder.Build();
app.UseAuthentication();
app.MapSentinelAuth();      // /auth/login, /auth/mfa/verify, /auth/refresh, /auth/logout…
app.MapSentinelProfile();   // /profile/me, /profile/sessions, /profile/permissions
```

Stores before the engine, always — register the EF stores after `AddSentinel()` and
they silently lose to in-memory defaults. Five ports have **no** default on purpose
(`IUserStore`, `IMfaStore`, `ISessionStore`, `ISubjectDataSource`,
`IMachineIdentityStore`); `AddSentinelEfCoreStores` supplies all five.

The rest of the surface mounts the same way when needed: `MapSentinelPasskeys()`,
`MapSentinelFederation()`, `MapSentinelOidc()`, `MapSentinelSaml()`,
`MapSentinelScim()`, `MapSentinelAdmin()`.

Read the principal with `HttpContext.GetSentinelPrincipal()` / `GetSentinelSnapshot()`
or the injected `ISentinelContextAccessor`.

## Non-negotiables

- **Never weaken a fail-closed default to make something work.** If a call is
  refused, find out why. Every refusal in Sentinel is a deliberate security
  decision, and the docs say which one.
- **Signing keys.** Sentinel will not invent keys silently. Production loads the key
  ring from the persisted store; ephemeral keys are an explicit dev-only opt-in
  (`AllowEphemeralDevelopmentKeys = true`). Never set that outside development.
  Initialize the ring at startup with `SentinelHost.InitializeAsync(app.Services)`.
- **Permission grammar.** `service:scope:action`, lowercase `[a-z0-9_-]+` per
  segment, scope ∈ `global | org | team | self`. **Dots are not allowed inside a
  segment** — `patients.notes:org:read` throws; use `patients_notes:org:read`.
  `PermissionId` (what code checks) is always concrete; `PermissionPattern` (what
  grants hold) allows at most one `*` per service/action segment, and the scope
  segment must be `*` or a whole concrete scope.
- **Evaluation semantics.** Default deny → deny overrides every allow, everywhere →
  scope must apply → ABAC conditions must hold. A missing attribute makes every
  comparison false, **including `ne`**. Roles and groups flatten to grants; the
  evaluator has no concept of a role.
- **Never widen what reaches the browser.** `GET /profile/permissions` deliberately
  returns allow-effect patterns and team ids only. Deny grants, conditions, org
  scoping and provenance stay server-side.
- **Declare permissions in code** and let definition sync reconcile them at boot. An
  unpublished permission id fails the boot rather than the request — that is the
  feature, not a bug to route around.
- **Secrets never live in config files.** Declarative YAML names an environment
  variable via `secretRef`, resolved through `ISecretResolver`.
- **Do not hand-roll what Sentinel already does.** Password hashing, token rotation,
  timing-safe user lookup, SAML signature validation, PKCE, webhook signing — all
  present, all tested against golden vectors and acceptance tests. A hand-rolled
  version is a vulnerability with extra steps.

## Working patterns

**Adding a capability.** Find the row above → read the doc page → read the article
(a working tutorial with a compiling sample) → check the matching security recipe
for what the *host app* still owes → implement. Follow the codebase's existing
conventions where they differ from the docs.

**Changing anything on the attack surface.** Login, token issuance, redirect
handling, webhook receipt, multi-org access, MFA — read the relevant
`security/*.md` recipe first and say explicitly which mechanism carries the
guarantee. The ten recipes cover session fixation, token theft and reuse detection,
SAML signature wrapping, user enumeration, credential stuffing, authorization code
interception, XSS and token storage, cross-org privilege escalation, MFA replay and
fatigue, and webhook forgery.

**Reviewing.** Confirm: no dev-key flags outside development; audience and issuer
set; every new permission id published through definition sync; grants scoped to
the narrowest scope that works; no deny grant or condition leaking to a client; no
error path that distinguishes "no such user" from "wrong password".

**Debugging authorization.** Do not guess — trace. Pass an `EvaluationTrace` and
every grant reports `PatternMismatch`, `ScopeNotApplicable`, `ConditionFailed`,
`Allowed` or `Denied`. The admin surface exposes this as
`POST /sentinel-admin/authz/inspect`, which loads a fresh snapshot rather than the
cache. Remember snapshots are per-`(user, org)`: an org switch is a different
snapshot, so a stale cache and a wrong org look alike until you trace.

**Migrating an existing system.** Import with dry-run first, keep foreign password
hashes so nobody resets a password, then run shadow mode — Sentinel's evaluator
silently beside the legacy one — and cut over only when the divergence counter is
zero. `docs/migration.md` and `articles/shadow-mode-migration.md`.

**Deciding embedded vs Server.** One product, one team → embed. Many apps, one
identity domain → run the Sentinel Server container and make the apps OIDC clients.
Same packages either way, so embedding now does not close the door.
`docs/deployment.md` has the decision table.

## Sentinel with Relay

`Nuvora.Nexus.Sentinel.Relay` bridges the two without coupling either: it projects
`SentinelPrincipal` and its permission snapshot onto Relay's `AuthContext`, makes
`[RequirePermission("service:scope:action")]` evaluate against Sentinel's engine,
and maps the `org` claim onto Relay's `TenantContext` — so an org-less token
resolves no tenant and `[TenantScoped]` handlers fail closed. Note the middleware
swap: `app.UseSentinelRelayAuthContext()` **replaces** `UseRelayAuthContext()`. See
`articles/relay-bridge.md` and the `nuvora-relay` skill.

## Reference files

- `references/doc-map.md` — every documentation page, article, security recipe, API
  page and story, with its URL and one-line summary.
- `scripts/fetch-docs.sh` — cached fetcher for the site's Markdown pages.
