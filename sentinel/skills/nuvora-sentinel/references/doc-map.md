# Nuvora Nexus Sentinel — documentation map

Snapshot of <https://sentinel.nuvoralabs.com/llms.txt>, taken 2026-08-14. It is a **fast path, not
the source of truth**. The live index always wins:

```bash
scripts/fetch-docs.sh index          # refresh this list
scripts/fetch-docs.sh search <term>  # find a page by keyword
scripts/fetch-docs.sh get <path>     # read a page
```

If a link below 404s, or you need a page that is not listed, refresh the index
rather than guessing a URL.

Articles are paired with sample projects under
<https://github.com/nuvoralabs/sentinel-examples>; the article-to-sample mapping
lives at <https://sentinel.nuvoralabs.com/agent.md>.

---


> Sentinel is a batteries-included, embeddable, code-first identity provider, authentication, and authorization platform for .NET. This site is its documentation portal: reference docs, hands-on tutorial articles (each paired with a runnable sample), the generated API reference, and security recipes that map real attack classes to the mechanisms that counter them.

Every page below is available as clean Markdown at the linked `.md` URL. A single concatenated copy of all content lives at https://sentinel.nuvoralabs.com/llms-full.txt.

## Start here for agents

- [Agent guide](https://sentinel.nuvoralabs.com/agent.md): what Sentinel is, plus every capability mapped to its docs and articles.
- [Documentation index](https://sentinel.nuvoralabs.com/docs.md): all documentation pages in one list.

## Documentation

- [What is Sentinel](https://sentinel.nuvoralabs.com/docs/what-is-sentinel.md): A batteries-included, embeddable, code-first identity provider, authentication and authorization platform for .NET — the identity store for your apps and a standards-compliant OIDC/SAML/SCIM server for everyone else's.
- [Getting started](https://sentinel.nuvoralabs.com/docs/getting-started.md): Wire Sentinel into an ASP.NET Core app — EF Core stores, the engine, the authentication handler, the endpoint groups — and make your first login, refresh and authenticated call.
- [Authentication & factors](https://sentinel.nuvoralabs.com/docs/authentication.md): Passkeys-first authentication for .NET — password with argon2id, WebAuthn as first or second factor, TOTP, email OTP, recovery codes, refresh-token families, risk-based step-up and four layers of abuse protection.
- [Authorization engine](https://sentinel.nuvoralabs.com/docs/authorization.md): RBAC + ABAC with a formal grammar — service:scope:action permissions, per-segment wildcards, deny-overrides, a JSON condition AST, one evaluation path for checks and visibility, and golden vectors that pin the .NET and TypeScript evaluators to each other.
- [OIDC provider](https://sentinel.nuvoralabs.com/docs/oidc-provider.md): An in-house OAuth2/OIDC authorization server inside your app — authorization code + PKCE, client credentials, refresh tokens, discovery, JWKS, introspection, revocation, RP-initiated and back-channel logout, with app-owned login UI.
- [Enterprise SSO & multi-org](https://sentinel.nuvoralabs.com/docs/enterprise.md): SAML 2.0 on both sides with a hardened XML-DSig pipeline, generic OIDC federation with JIT provisioning, SCIM 2.0 Users and Groups, email-domain org discovery, and delegated administration fenced in the domain layer.
- [Machine identity](https://sentinel.nuvoralabs.com/docs/machine-identity.md): Service accounts with rotating secrets, snt_ API keys capped by the owner's live permissions, and workload identity federation that swaps GitHub Actions or Kubernetes OIDC tokens for Sentinel tokens — secretless CI/CD.
- [Operations](https://sentinel.nuvoralabs.com/docs/operations.md): Signed and retried webhooks, a dual audit ledger with a tamper-evident hash chain, time-boxed impersonation with consent, break-glass with mandatory rotation and drill health checks, and the admin console.
- [Compliance & privacy](https://sentinel.nuvoralabs.com/docs/compliance.md): GDPR Article 17 and 20 endpoints, per-user crypto-shredding with AES-256-GCM, retention sweeps with hash-chain-aware redaction, and six shipped languages behind a localizer port.
- [Deployment](https://sentinel.nuvoralabs.com/docs/deployment.md): Embed Sentinel as packages, run the Sentinel Server container, or both — plus declarative YAML realm config with dry-run diffs, storage adapters, and the Relay bridge.
- [Migration & importers](https://sentinel.nuvoralabs.com/docs/migration.md): Importers for ASP.NET Core Identity, Keycloak, Auth0 and Duende; foreign password hashes that verify from day one with rehash-on-login; and shadow-mode authorization that gates cutover on zero divergence.

## API reference

- [Nuvora.Nexus.Sentinel](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel.md): Sentinel entry point: AddSentinel() dependency-injection wiring, options, and startup guards. Sentinel is a batteries-included, embeddable identity provider, authentication, and authorization platform for .NET.
- [Nuvora.Nexus.Sentinel.Core](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-core.md): Framework-free domain core for Sentinel: permission grammar, authorization evaluator, policy engine, identity model, and ports. No web framework, no storage dependencies.
- [Nuvora.Nexus.Sentinel.AspNetCore](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-aspnetcore.md): ASP.NET Core surface for Sentinel: the "Sentinel" authentication handler (Bearer + httpOnly cookie with CSRF double-submit), the request principal/context accessor, and mountable minimal-API endpoint groups (MapSentinelAuth, MapSentinelProfile).
- [Nuvora.Nexus.Sentinel.OidcServer](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-oidcserver.md): In-house OAuth2/OIDC authorization server for Sentinel (no OpenIddict): discovery, JWKS, authorization code + PKCE, client credentials, refresh token grants, userinfo, revocation (RFC 7009), introspection (RFC 7662), RP-initiated + back-channel logout, client registry and consent — with a host-app interaction contract for login and consent UI.
- [Nuvora.Nexus.Sentinel.Saml](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-saml.md): SAML 2.0 for Sentinel, both sides: SP-initiated inbound SSO against external IdPs with hardened XML-DSig validation, and Sentinel-as-IdP issuing signed assertions to a registered SP registry with attribute mapping, metadata and redirect/POST bindings.
- [Nuvora.Nexus.Sentinel.Scim](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-scim.md): SCIM 2.0 provisioning server for Sentinel: per-organization bearer-token auth, Users AND Groups (fixes the Node version's users-only gap), the standard filter subset, and RFC 7644 PATCH — mounted with MapSentinelScim().
- [Nuvora.Nexus.Sentinel.Stores.EfCore](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-stores-efcore.md): EF Core persistence adapter for Sentinel: provider-neutral identity/authorization model with ModelBuilder extensions per Relay's .EfCore conventions. Works on PostgreSQL, SQL Server and SQLite.
- [Nuvora.Nexus.Sentinel.Stores.ValKey](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-stores-valkey.md): ValKey/Redis hot-state adapter for Nuvora Nexus Sentinel: fleet-wide rate counters and cache-invalidation pub/sub (works with any Redis-compatible server)
- [Nuvora.Nexus.Sentinel.Relay](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-relay.md): Relay bridge for Sentinel: feeds Relay's AuthContext from the Sentinel principal, evaluates Relay [RequirePermission] attributes against Sentinel's authorization engine (grants, wildcards, deny-overrides), and maps the org claim onto Relay's TenantContext.
- [Nuvora.Nexus.Sentinel.DeclarativeConfig](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-declarativeconfig.md): Declarative realm configuration for Sentinel: a versioned YAML/JSON model for realms, organizations, roles, OIDC clients, SAML connections, identity providers, workload trusts and webhook endpoints, with an idempotent diff-aware applier over the public store ports.
- [Nuvora.Nexus.Sentinel.Importers](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-importers.md): Migration importer suite for Sentinel: ASP.NET Core Identity, Keycloak realm-export, Auth0 bulk export and Duende client-config importers, foreign-hash coexistence (bcrypt), and shadow-mode authorization for cutover gating. Library-only — callable from CLIs and hosts, no web framework.
- [Nuvora.Nexus.Sentinel.Admin](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-admin.md): Sentinel admin console: the React admin UI shipped as embedded static assets and served by MapSentinelAdminUi — consumers never run Node tooling.
- [Nuvora.Nexus.Sentinel.Diagnostics](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-diagnostics.md): OpenTelemetry instrumentation for Nuvora Nexus Sentinel: ActivitySource/Meter registration helpers and the meter-backed metrics implementation (logins, token mints, authorization checks, webhook deliveries)
- [Nuvora.Nexus.Sentinel.Client](https://sentinel.nuvoralabs.com/api/nuvora-nexus-sentinel-client.md): .NET client for the Sentinel HTTP surface: typed auth + profile calls over Bearer or cookie transport, in-memory token handling with auto-refresh, API-key mode for machines, a DelegatingHandler for service-to-service calls, and client-side can() running the same golden-vector-tested evaluator as the server.

## Articles

### Getting Started
- [001 — Your first login](https://sentinel.nuvoralabs.com/articles/first-login.md): Stand up a Sentinel host from nothing — EF stores, the engine, the authentication handler — and walk a real login, refresh and authenticated request through it.
- [018 — Sentinel meets Relay](https://sentinel.nuvoralabs.com/articles/relay-bridge.md): Bridge Sentinel into a Relay application — the login token becomes Relay's AuthContext, [RequirePermission] on a command is decided by the real authorization engine, and the org claim becomes the ambient tenant.

### Authentication & Factors
- [004 — Passkeys, first-class](https://sentinel.nuvoralabs.com/articles/passkeys.md): Register a passkey, sign in without a password, and use a passkey as a second factor — the full WebAuthn ceremony flow with Sentinel's eligibility rules, sign-count defense and phishing-resistant session marking.
- [013 — Four layers before the database](https://sentinel.nuvoralabs.com/articles/abuse-protection-layers.md): The abuse gate every Sentinel login passes before a single user lookup — per-IP, per-IP-and-account, lockout, credential-stuffing heuristics — plus the adaptive captcha band and the outage policy each layer declares.
- [014 — Risk, scored in the open](https://sentinel.nuvoralabs.com/articles/adaptive-risk-engine.md): Deterministic, explainable risk signals on every login — the built-in IRiskSignal set, the step-up and block thresholds, the email-OTP fallback, and the new-device alert mail.

### Authorization Engine
- [002 — The permission grammar, evaluated](https://sentinel.nuvoralabs.com/articles/permission-grammar-and-evaluation.md): Learn service:scope:action from the inside — patterns and wildcards, deny-overrides, org/team/self scoping, ABAC conditions, and the golden vectors that make the server and the browser agree.

### Tokens & Sessions
- [003 — Refresh-token families](https://sentinel.nuvoralabs.com/articles/refresh-token-families.md): Why every refresh rotates, what a token family is, and how replaying a stolen token detonates the whole lineage — with the exact service, store contract and tests behind it.

### Enterprise SSO & Federation
- [005 — Multi-org membership & delegated admin](https://sentinel.nuvoralabs.com/articles/multi-org-and-delegated-admin.md): Model realm → organizations → teams, put one user in two orgs, switch org context without re-login, and hand each org an admin who structurally cannot touch the other — the fence lives in the evaluator, not the controller.
- [009 — SCIM provisioning](https://sentinel.nuvoralabs.com/articles/scim-provisioning.md): Serve a real SCIM 2.0 surface from your own app — Users and Groups under /scim/v2, per-organization sct_ bearer tokens, soft-delete, and the org fences that make multi-tenant provisioning safe.
- [010 — SAML in both directions](https://sentinel.nuvoralabs.com/articles/saml-both-directions.md): Run Sentinel as SAML service provider AND identity provider in a single process — the loopback technique its own acceptance tests use — with pinned-certificate verification and both metadata documents.

### Machine Identity
- [007 — Workload identity federation](https://sentinel.nuvoralabs.com/articles/workload-identity-federation.md): Delete the deploy secrets — configure a trust for GitHub Actions or Kubernetes OIDC tokens and exchange them for short-lived Sentinel access tokens, with wildcard subject matching and audited denials.
- [019 — API keys, owner-capped](https://sentinel.nuvoralabs.com/articles/api-keys-owner-capped.md): Mint snt_ keys whose effective permissions are the owner's current grants intersected with the key's scopes at every use — denies preserved, demotion shrinks keys instantly, and revocation fails as opaquely as a typo.

### Operations & Administration
- [006 — An OIDC server inside your app](https://sentinel.nuvoralabs.com/articles/oidc-server-in-your-app.md): Turn the host you already have into a standards-compliant OIDC provider — discovery, a confidential client, the code + PKCE flow with your own login UI, introspection and back-channel logout.
- [011 — Webhooks that survive](https://sentinel.nuvoralabs.com/articles/webhooks-that-survive.md): Sentinel's webhook pipeline end to end — durable outbox, HMAC-signed deliveries, the exact verification recipe for your receiver, and the retry/backoff ladder that outlives a receiver outage.
- [012 — The audit log that notices](https://sentinel.nuvoralabs.com/articles/tamper-evident-audit.md): Every admin mutation appends to a per-realm hash chain that re-verifies on every read — how the chain is built, what tampering looks like when it fails, and why redaction doesn't break it.
- [015 — Break-glass & impersonation](https://sentinel.nuvoralabs.com/articles/break-glass-and-impersonation.md): Let an admin act as a user on a signed, time-boxed, audited token the UI cannot hide — and keep an emergency account whose grants are structurally capped, whose logins ring alarms, and whose drills are health-checked.
- [017 — Config as code](https://sentinel.nuvoralabs.com/articles/config-as-code.md): Declare realms, orgs, roles and OIDC clients in YAML, apply idempotently at every boot, read drift as a field-level diff report — and see why the applier refuses to delete anything it merely stopped seeing.

### Compliance & Migration
- [008 — Shadow-mode migration](https://sentinel.nuvoralabs.com/articles/shadow-mode-migration.md): Import your users, run Sentinel's evaluator silently beside your legacy authorization, turn every disagreement into a reviewable event, and cut over only when the divergence counter reads zero.
- [016 — GDPR & crypto-shredding](https://sentinel.nuvoralabs.com/articles/gdpr-crypto-shredding.md): Export everything Sentinel holds about a person, erase them in one operation — shred the key, anonymize the row, redact the ledgers — and watch the tamper-evident audit chain still verify afterwards.
- [020 — Importing identity](https://sentinel.nuvoralabs.com/articles/importing-identity.md): Four importers, one target — ASP.NET Identity V3 hashes that verify and rehash on login, Keycloak realm exports, Auth0 ndjson with bcrypt, and Duende clients whose unrecoverable secrets rotate on the way in. Dry-run everything first.

## Security recipes

- [Session fixation](https://sentinel.nuvoralabs.com/security/session-fixation.md): An attacker plants a session identifier before login and inherits the victim's authenticated session — and why Sentinel's post-authentication, server-minted session model leaves the attack nothing to fixate on.
- [Token theft & reuse detection](https://sentinel.nuvoralabs.com/security/token-theft-and-reuse-detection.md): A stolen refresh token is a month of silent access — unless replaying it detonates the whole token family. How Sentinel's rotation and reuse detection turn theft into an alarm, and the runbook for the alarm.
- [SAML signature wrapping](https://sentinel.nuvoralabs.com/security/saml-signature-wrapping.md): The XML-DSig attack class that broke a decade of SAML stacks — moving a validly-signed element and consuming an injected one — and the five-layer verification pipeline that makes Sentinel consume only what was signed.
- [User enumeration](https://sentinel.nuvoralabs.com/security/user-enumeration.md): Login, reset and registration endpoints that answer "no such user" differently from "wrong password" hand attackers a verified target list. How Sentinel makes the two indistinguishable — by response, by timing, and by side effect.
- [Credential stuffing](https://sentinel.nuvoralabs.com/security/credential-stuffing.md): Billions of breached email/password pairs, replayed against your login at low per-IP rates. How Sentinel's four windowed layers, distinct-identifier heuristic, adaptive CAPTCHA and risk engine raise the cost curve — and what happens when the counter store goes down.
- [Authorization code interception](https://sentinel.nuvoralabs.com/security/authorization-code-interception.md): A stolen redirect code is a login in transit — leaked through referrers, app-link hijacking or request logs. How Sentinel's S256-only PKCE, exact redirect_uri matching and detonating single-use codes make an intercepted code worthless.
- [XSS & token storage](https://sentinel.nuvoralabs.com/security/xss-and-token-storage.md): One injected script can read anything your page can — and if that includes tokens in localStorage, an XSS becomes durable offline credential theft. Why Sentinel's cookie transport keeps tokens out of JavaScript's reach entirely, and why its bearer mode refuses to persist.
- [Cross-org privilege escalation](https://sentinel.nuvoralabs.com/security/cross-org-privilege-escalation.md): In a multi-tenant system the classic escalation isn't up — it's sideways: an org admin reaching into an organization that never delegated anything to them. How Sentinel's effective-org rule, cross-org grant fencing and structural delegated administration close the lane.
- [MFA replay & fatigue](https://sentinel.nuvoralabs.com/security/mfa-replay-and-fatigue.md): A TOTP code shoulder-surfed or phished in real time is valid for another twenty seconds — and push notifications taught attackers that annoyance is a credential. How Sentinel's strictly-advancing step counter, single-use recovery codes and risk-gated step-up close the second factor's own attack surface.
- [Webhook forgery](https://sentinel.nuvoralabs.com/security/webhook-forgery.md): Your webhook receiver is an unauthenticated POST endpoint that mutates state — unless every delivery proves who sent it and when. How Sentinel's timestamp-bound HMAC signature and the WebhookSignature.Verify consumer recipe make forgery and replay fail the same five lines.

## Stories

### Meridian — A clinic platform learns that identity is the part of healthcare software you don't get to be casual about.
- [001 — The Night the Badge Didn't Work](https://sentinel.nuvoralabs.com/stories/the-night-the-badge-didnt-work.md): A credential-stuffing run walked straight through a hand-rolled login
- [002 — The First Login](https://sentinel.nuvoralabs.com/stories/the-first-login.md): Replacing a hand-rolled login without resetting a single password
- [003 — The Second Clinic](https://sentinel.nuvoralabs.com/stories/the-second-clinic.md): One physician, two clinics, and permissions that follow context
- [004 — The Contractor Who Crossed Clinics](https://sentinel.nuvoralabs.com/stories/the-contractor-who-crossed-clinics.md): An org admin's reach ends exactly at their own clinic's border
- [005 — The Passkey Rollout](https://sentinel.nuvoralabs.com/stories/the-passkey-rollout.md): The phishing email arrived — and bounced off origin-bound credentials
- [006 — The Enterprise Customer](https://sentinel.nuvoralabs.com/stories/the-enterprise-customer.md): Closing the deal that required SSO and provisioning to be real
- [007 — The 3 A.M. Page](https://sentinel.nuvoralabs.com/stories/the-3am-page.md): An IdP outage, a patient emergency, and a rehearsed escape hatch
- [008 — The Quiet Audit](https://sentinel.nuvoralabs.com/stories/the-quiet-audit.md): A compliance review where the evidence verified itself
- [009 — The Leaked CI Token](https://sentinel.nuvoralabs.com/stories/the-leaked-ci-token.md): A secret in the build logs — and the machinery that made secrets unnecessary
- [010 — The Right to Be Forgotten](https://sentinel.nuvoralabs.com/stories/the-right-to-be-forgotten.md): Erasing a person completely — while every audit still verifies
