---
name: nuvora-sentinel
description: Build, review and debug identity, authentication and authorization on Nuvora Nexus Sentinel — the embeddable, code-first identity provider for .NET. Covers drop-in ASP.NET Core authorization ([SentinelPermission], permission ids as [Authorize(Policy)], resource binding, list visibility), passkeys and MFA, refresh-token families, the service:scope:action permission grammar with RBAC + ABAC, the in-house OIDC server, SAML both directions, SCIM provisioning, multi-org and delegated admin, machine identity, webhooks, tamper-evident audit, GDPR crypto-shredding, and migration from Keycloak/Auth0/ASP.NET Identity. Always reads current documentation from sentinel.nuvoralabs.com. Use whenever the work touches Nuvora.Nexus.Sentinel.* packages, AddSentinel, AddSentinelAuthorization, MapSentinelAuth, [SentinelPermission], RequireSentinelPermission, SentinelPrincipal, PermissionId, snt_ API keys, or when the user asks anything about Sentinel.
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
| Guarding ASP.NET Core endpoints, migrating `[Authorize(Policy)]` / `[Authorize(Roles)]` | `docs/authorization.md` | `articles/aspnet-authorization.md`, `api/nuvora-nexus-sentinel-authorization-aspnetcore.md` |
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

## Guarding endpoints — plain ASP.NET Core

`Nuvora.Nexus.Sentinel.Authorization.AspNetCore` is the drop-in path for any
ASP.NET Core app. **This is the default choice for controllers and minimal APIs.**
(A Relay app uses the Relay bridge instead — see the last section.)

```csharp
builder.Services.AddSentinelAuthorization();

app.UseAuthentication();
app.UseAuthorization();
```

That single registration installs `SentinelAuthorizationPolicyProvider`, and **any
policy name that parses as a permission id is answered by Sentinel's evaluator** —
same grammar, wildcards, deny-overrides and org scoping as everywhere else. Existing
attributes start resolving against the real engine without being edited:

```csharp
[Authorize(Policy = "helpdesk:global:reports_read")]   // decided by Sentinel now
```

Policy names that are *not* permission ids (`"AdminOnly"`) fall through to the host's
own providers, so `AddPolicy(...)` keeps working and both styles coexist for as long
as the migration takes.

### Bind the resource — this is the whole point

A permission checked with no resource context asks only "may this caller do this *at
all*?" For an org-scoped permission the check then falls back to the **caller's own**
organization and passes — even when the row belongs to somebody else. That is the
classic multi-tenant hole, and it looks guarded.

```csharp
// Wrong: the attribute passes, then the handler reads someone else's org from the URL.
[HttpGet("orgs/{orgId:guid}/tickets")]
[Authorize(Policy = "helpdesk:org:tickets_read")]
public IActionResult List(Guid orgId) => Ok(_tickets.InOrganization(orgId));

// Right: the check is about the organization in the route.
[SentinelPermission("helpdesk:org:tickets_read", Organization = "{orgId}")]
```

`[SentinelPermission]` takes `Organization`, `Team` and `Owner` — each a route
parameter written `"{orgId}"` or a literal id — or a `ResolverType` when the facts
require a lookup. `ResolverType` is mutually exclusive with the three binding
properties; a resource in several teams needs a resolver rather than `Team`.

Lambdas cannot carry attributes, so inline minimal-API handlers use the fluent form,
which attaches identical metadata:

```csharp
app.MapGet("/orgs/{orgId}/tickets", Handler)
   .RequireSentinelPermission("helpdesk:org:tickets_read", organization: "{orgId}");
```

A resolver implements `ISentinelResourceResolver` and returns
`SentinelResourceResolution.Found(new SentinelResourceContext(...))` or
`SentinelResourceResolution.NotFound`. There is deliberately no third "unknown"
state and no nullable result. **A resolver that cannot do its job must throw** — it
surfaces as a 500, because a fault dressed up as a denial is invisible in the logs.

### Startup refuses guards that only look like guards

`AddSentinelAuthorization()` validates every mounted endpoint at startup and reports
*all* problems at once: an org- or team-scoped permission with nothing bound, a
binding naming a route value the route does not define, an unregistered resolver, a
permission never published to the catalog, or an `[Authorize(Roles = …)]` the role
shim does not map.

When an endpoint genuinely concerns no particular record, say so explicitly —
`AcknowledgesUnboundResource = true` on the attribute, or
`acknowledgesUnboundResource: true` on the fluent call. It is greppable on purpose.
Team- and self-scoped permissions cannot use it (unanswerable without a resource).

**Do not "fix" a startup failure by setting
`AllowUnacknowledgedUnboundResources = true`.** That is a migration aid, not a
destination — it converts the failure to a warning and leaves the hole open. Bind
the resource instead. `ValidateSentinelAuthorizationAsync()` runs the same pass on
demand, which makes a good test.

### Lists

Point checks answer one record at a time. For collections, ask before querying:

```csharp
var scope = HttpContext.GetSentinelListScope("helpdesk:team:notes_read");

return scope?.Level switch
{
    null or VisibilityLevel.None => Results.Ok(Array.Empty<Ticket>()),  // never query
    VisibilityLevel.Granted      => Results.Ok(await tickets.ListAsync(scope.OrganizationId)),
    _                            => Results.Ok(await tickets.ForTeamsAsync(scope.OrganizationId, scope.TeamIds)),
};
```

`null` (no authenticated Sentinel subject) and `None` both mean show nothing.
**`Conditional` is an instruction to filter, never permission to return everything.**
`SentinelListScope.OrganizationId` is always the *caller's* org — never a value taken
from the request. Because visibility comes from the same evaluation pass as a point
check, a list cannot show what a check would refuse.

### Roles, on the way out

```csharp
services.AddSentinelAuthorization(o =>
    o.RoleCompatibility.MapRole("Supervisor", "helpdesk:global:reports_read"));
```

The role is granted only to callers who actually hold that permission, so the engine
still decides. Sentinel has no roles at decision time — roles, groups and policies
flatten to grants before the evaluator runs — so the mapping cannot be inferred and
must be written by hand. Treat these entries as something to delete. Machine callers
(API keys, service accounts) are never granted a role; check them against the
permission.

### ABAC context attributes

`o.ContextAttributes` publishes request facts to conditions as `context.*`, each
opt-in because an attribute appearing unrequested can change what an existing
condition means: `IncludeIpAddress` (`context.ip`), `IncludeMfaLevel`
(`context.mfa_level`: `none` / `mfa` / `phishing_resistant`), `IncludePrincipalKind`
(`context.principal_kind`: `user` / `api_key` / `service_account`),
`IncludeImpersonation` (`context.is_impersonated`), `IncludeRequestTime`
(`context.time_utc`), and `Enrich` for host-specific values.

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
- **Every org-, team- or self-scoped endpoint check binds its resource.** An
  unbound org-scoped check falls back to the caller's own organization and passes on
  other people's rows. Bind it, resolve it, or acknowledge it explicitly — never
  relax the startup validation to get past it.
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
error path that distinguishes "no such user" from "wrong password". On endpoints:
every org/team/self check binds a resource; `AllowUnacknowledgedUnboundResources`
is off; `AcknowledgesUnboundResource` appears only where the endpoint really is not
about a row; list handlers treat `Conditional` as *filter*, not *allow all*; role
mappings are shrinking rather than growing.

**Migrating an app that already authorizes.** Register
`AddSentinelAuthorization()`, let existing `[Authorize(Policy = "…")]` attributes
resolve against the engine, then move endpoint by endpoint to `[SentinelPermission]`
with the resource bound. Map legacy roles only as a temporary shim.
`articles/aspnet-authorization.md` is the walkthrough.

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

## Which integration package

| The app is | Use | Guards look like |
|---|---|---|
| Controllers / minimal APIs (plain ASP.NET Core) | `Nuvora.Nexus.Sentinel.Authorization.AspNetCore` → `AddSentinelAuthorization()` | `[SentinelPermission]`, `[Authorize(Policy = "svc:scope:action")]`, `.RequireSentinelPermission(...)` |
| A Relay app (messages and handlers) | `Nuvora.Nexus.Sentinel.Relay` → `AddSentinelRelayAuthorization()` | `[RequirePermission("svc:scope:action")]` on the message |
| Both (Relay messages *and* hand-written endpoints) | Both — they decide with the same evaluator | each in its own layer |

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
