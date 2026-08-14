---
name: nuvora-relay
description: Build, review and debug .NET services on Nuvora Nexus Relay — the DDD / CQRS / event-sourcing framework. Covers commands and handlers, aggregates, the PostgreSQL event store, projections and read models, outbox/inbox and the nine transports, sagas and routing slips, scheduling, multi-tenancy, declarative authorization, and production operations. Always reads current documentation from relay.nuvoralabs.com. Use whenever the work touches Nuvora.Nexus.Relay.* packages, AddRelay, ICommand / IQuery / ICommandHandler, [RelayHttpPost], MapRelayEndpoints, IEventStore, IProjection, [TenantScoped], [RequirePermission], or when the user asks anything about Relay.
license: MIT
---

# Nuvora Nexus Relay

Relay is a batteries-included DDD / CQRS / event-sourcing framework for .NET 10.
A message is a record, a handler owns its behavior, and a pipeline of behaviors
applies validation, authorization, logging and the transaction to every message
uniformly. Everything else — event sourcing, projections, outbox, sagas, tenancy —
is built out of that.

## Read the live docs before you write code

Relay ships ~40 packages and moves fast. **Do not answer from memory and do not
invent APIs.** For any non-trivial question or code change, fetch the relevant
page first — every page on the site is available as clean Markdown by appending
`.md` to its path.

```bash
scripts/fetch-docs.sh get docs/event-sourcing articles/outbox
scripts/fetch-docs.sh search projection rebuild     # find pages by keyword
scripts/fetch-docs.sh index                         # the whole page index (llms.txt)
scripts/fetch-docs.sh api Nuvora.Nexus.Relay.Sagas  # generated API reference
```

The script caches for 6 hours under `$TMPDIR`, so repeat fetches in a session are
free. If it is unavailable, plain `curl -sL https://relay.nuvoralabs.com/<path>.md`
does the same job, and `WebFetch` works too.

Routing rule:

1. **Concepts and "how does X work"** → `docs/<topic>.md` (the reference).
2. **"How do I actually build X"** → `articles/<slug>.md` (numbered, hands-on
   tutorials, each with a runnable sample at
   `github.com/nuvoralabs/relay-examples/tree/main/<NNN>-<slug>`).
3. **Exact type, method or option names** → `api/nuvora-nexus-relay-<pkg>.md`.
4. **Nothing matches** → run `scripts/fetch-docs.sh index` and route from there;
   the index is the source of truth, this file is a fast path.

Prefer two or three targeted pages over `llms-full.txt` (~830 KB — last resort only).

## Where to look

| The task is about | Start here | Then |
|---|---|---|
| First service, commands, queries, handlers | `docs/quickstart.md`, `docs/core-concepts.md` | `articles/getting-started.md` |
| Aggregates, domain events, error → HTTP mapping | `docs/foundations.md` | `articles/first-aggregate.md`, `articles/domain-events.md`, `articles/errors-and-http.md` |
| Event store, concurrency, snapshots, schema evolution, time travel, archiving | `docs/event-sourcing.md` | `articles/event-sourcing-basics.md`, `articles/concurrency-and-snapshots.md`, `articles/schema-evolution.md` |
| Projections, read models, rebuilds, sharding, query caching | `docs/projections.md` | `articles/projections.md`, `articles/projection-operations.md`, `articles/caching-queries.md` |
| Outbox, inbox, brokers, exactly-once effects | `docs/messaging.md` | `articles/outbox.md`, `articles/inbox.md`, `articles/reliable-messaging.md` |
| Sagas, state machines, routing slips, compensation | `docs/workflows.md` | `articles/sagas.md`, `articles/state-machine-sagas.md`, `articles/routing-slips.md` |
| Delayed commands, recurring jobs | `docs/scheduling.md` | `articles/scheduling.md`, `articles/recurring-jobs.md` |
| Multi-tenancy and authorization | `docs/tenancy-security.md` | `articles/authorization.md`, `articles/multi-tenancy.md` |
| Telemetry, resiliency, locks, leader election, Relay Watch | `docs/operations.md` | `articles/observability.md`, `articles/resiliency.md`, `articles/distributed-coordination.md` |
| Which NuGet package do I need | `docs/packages.md` | — |
| A full production shape, end to end | `articles/reference-architecture.md` | — |

`references/doc-map.md` has the complete page list, including all 38 articles and
the 30 narrative stories.

## The shape of Relay code

Verify specifics against the docs; this is the mental model, not an API contract.

**A message is an immutable record.** `ICommand` / `ICommand<TResponse>` for state
changes, `IQuery<TResponse>` for reads. Data only — no behavior, no services.

**A handler is one class with one `Handle` method**, resolved from DI.
`ICommandHandler<TCommand, TResponse>` / `IQueryHandler<TQuery, TResponse>`. One
message, one handler: the `RelayHandlerAnalyzer` fails the build on a missing
handler (RELAY001) or a duplicate (RELAY002).

**HTTP is generated from the message.** `[RelayHttpPost("/products")]` plus
`MapRelayEndpoints()` — you rarely hand-write a controller or minimal-API route.

**Registration is one assembly scan.** `builder.Services.AddRelay(typeof(SomeCommand).Assembly)`
finds every handler, validator and behavior. There is no per-handler wiring; if you
find yourself registering handlers by hand, that is a smell.

**Cross-cutting concerns are pipeline behaviors**, ordered by priority and applied
to every message. Add one once and every present and future handler gets it.

A typical host:

```csharp
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddRelay(typeof(CreateProductCommand).Assembly);

var app = builder.Build();
app.UseRelayExceptionHandling();               // ProblemDetails + correlation ids
app.UseRouting();
app.UseEndpoints(e => e.MapRelayEndpoints());  // endpoints from [RelayHttp*]
app.Run();
```

## Non-negotiables — get these wrong and the host will not start

- **Authorization is fail-closed.** Every message must declare a posture —
  `[AllowAnonymous]`, `[RequireRole]`, `[RequirePermission]`, `[RequireClaim]`,
  `[RequirePolicy]`, or a custom `IAuthorizationPolicy`. A message with none stops
  the host at startup. When you add a command or query, add its posture in the same
  edit; `[AllowAnonymous]` is a decision you state out loud, never a default.
- **Tenancy is fail-closed too.** `[TenantScoped]` or `[GlobalOperation]` — pick
  deliberately. Storage isolation is a separate choice: shared tables with row-level
  security, schema-per-tenant, or database-per-tenant.
- **Validation lives beside the command** as an `ICommandValidator<,>`; the pipeline
  runs it. Do not validate inside the handler.
- **Never query the event store for reads.** It is an append-only write-side log.
  Reads come from projections. (The one sanctioned exception is operational forensics —
  see `articles/operational-event-queries.md`.)
- **Events are immutable and forever.** Renaming or reshaping an event type breaks
  history. Use stable names and upcasters — read `articles/schema-evolution.md`
  *before* changing an event, not after.

## Working patterns

**Adding a feature.** Find the capability row above → read the doc page → read the
matching article (it is a working tutorial, and its sample repo compiles) → write
the message, the handler, the validator, and the authorization/tenancy posture
together. Follow the conventions already in the codebase over the ones in the docs
where they differ.

**Choosing packages.** Start from `Nuvora.Nexus.Relay` (meta) and add focused
packages as capabilities are adopted. `.EfCore` = the PostgreSQL/EF Core
implementation of a capability whose abstractions live in the base package.
`.Messaging.*` = one package per broker, all behind the same `IMessageBroker` /
`IMessageConsumer` contract, so transports swap without code changes. `.ValKey` =
Redis-compatible implementations. Check `docs/packages.md` for the current list and
version — do not guess a package name.

**Debugging.** Match the symptom to the capability, then read that doc's operational
section. Duplicate side effects → inbox/idempotency. Stale read models → projection
checkpoints and rebuilds. Message saved but never published (or the reverse) →
outbox. A stuck multi-step process → sagas and compensation. Two instances doing the
same job → distributed coordination.

**Reviewing.** Check the fail-closed postures are present and correct, that reads
come from projections rather than the event store, that new events have stable names
and an upcaster path, and that handlers stay thin — a handler reaching into
infrastructure is usually a missing behavior.

**Testing.** Samples are test-backed; `Nuvora.Nexus.Relay.Messaging.InMemory` runs
the full outbox → broker → inbox loop in-process, so reliability paths can be tested
without infrastructure.

## Relay with Sentinel

If the app also uses Nuvora Nexus Sentinel for identity, the
`Nuvora.Nexus.Sentinel.Relay` bridge feeds Relay's `AuthContext` from the Sentinel
principal, makes `[RequirePermission]` evaluate against Sentinel's authorization
engine, and maps the org claim onto Relay's `TenantContext`. That bridge is
documented on the *Sentinel* site, not this one:
<https://sentinel.nuvoralabs.com/articles/relay-bridge.md> and
<https://sentinel.nuvoralabs.com/docs/deployment.md>. See also the
`nuvora-sentinel` skill.

## Reference files

- `references/doc-map.md` — every documentation page, article, API page and story,
  with its URL and one-line summary.
- `scripts/fetch-docs.sh` — cached fetcher for the site's Markdown pages.
