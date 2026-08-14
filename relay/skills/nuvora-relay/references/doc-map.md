# Nuvora Nexus Relay — documentation map

Snapshot of <https://relay.nuvoralabs.com/llms.txt>, taken 2026-08-14. It is a **fast path, not
the source of truth**. The live index always wins:

```bash
scripts/fetch-docs.sh index          # refresh this list
scripts/fetch-docs.sh search <term>  # find a page by keyword
scripts/fetch-docs.sh get <path>     # read a page
```

If a link below 404s, or you need a page that is not listed, refresh the index
rather than guessing a URL.

Every article has a runnable sample repo; the mapping from article to sample lives
at <https://relay.nuvoralabs.com/agent.md>.

---


> Relay is a DDD / CQRS / event-sourcing framework for .NET. This site is its documentation portal: reference docs, a sequence of hands-on tutorial articles (each paired with a runnable sample), and narrative stories that teach the same ideas through fictional engineering teams.

Every page below is available as clean Markdown at the linked `.md` URL. A single concatenated copy of all content lives at https://relay.nuvoralabs.com/llms-full.txt.

## Start here for agents

- [Agent guide](https://relay.nuvoralabs.com/agent.md): what Relay is, plus every capability mapped to its docs, articles, and runnable samples.
- [Documentation index](https://relay.nuvoralabs.com/docs.md): all documentation pages in one list.

## Documentation

- [What is Relay?](https://relay.nuvoralabs.com/docs/what-is-relay.md): A DDD / CQRS / event-sourcing framework for .NET 10 — the batteries-included choice for services with real domain behavior.
- [Quickstart](https://relay.nuvoralabs.com/docs/quickstart.md): From zero to a running Relay service: install the package, define a command, and let the pipeline do the rest.
- [Core concepts](https://relay.nuvoralabs.com/docs/core-concepts.md): Messages, handlers, buses, behaviors — the five ideas everything else in Relay builds on.
- [Mediator & CQRS](https://relay.nuvoralabs.com/docs/foundations.md): One message, one handler, one pipeline — vertical slices with uniform cross-cutting concerns.
- [Event Sourcing](https://relay.nuvoralabs.com/docs/event-sourcing.md): An append-only PostgreSQL event store: full history, concurrency control, schema evolution, time travel — and the tools to run it for years.
- [Projections & Read Models](https://relay.nuvoralabs.com/docs/projections.md): Async read models with checkpoints, rebuilds, sharded lanes, blue/green deployments — plus declarative query caching.
- [Messaging & Reliability](https://relay.nuvoralabs.com/docs/messaging.md): Outbox, inbox, and nine transports behind one abstraction — exactly-once effects over at-least-once delivery.
- [Sagas & Workflows](https://relay.nuvoralabs.com/docs/workflows.md): Long-running processes as first-class citizens: sagas, declarative state machines, and routing slips with compensation.
- [Scheduling & Time](https://relay.nuvoralabs.com/docs/scheduling.md): Durable delayed commands and recurring jobs that survive restarts and never double-fire across a cluster.
- [Tenancy & Security](https://relay.nuvoralabs.com/docs/tenancy-security.md): Fail-closed multi-tenancy and declarative authorization — the WHERE clause you can't forget, the auth check that can't ship missing.
- [Production Operations](https://relay.nuvoralabs.com/docs/operations.md): Observability, resiliency, distributed coordination, and Relay Watch — the control plane for everything you shipped.
- [Packages](https://relay.nuvoralabs.com/docs/packages.md): The Nuvora.Nexus.Relay.* NuGet family: start with the meta package, add capabilities as focused packages.

## API reference

- [Nuvora.Nexus.Relay](https://relay.nuvoralabs.com/api/nuvora-nexus-relay.md): Core CQRS/DDD framework for Nuvora Nexus
- [Nuvora.Nexus.Relay.Core](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-core.md): Core abstractions for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Http](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-http.md): First-class HTTP endpoint model for Nuvora Nexus Relay (attribute-driven MapRelayEndpoints + OpenAPI)
- [Nuvora.Nexus.Relay.Web](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-web.md): Web API Utilities for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Persistence](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-persistence.md): Core persistence abstractions and interfaces for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Persistence.EfCore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-persistence-efcore.md): EF Core unit of work and event-sourced repository for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.EventStore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-eventstore.md): Core event store abstractions and implementations for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.EventStore.EfCore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-eventstore-efcore.md): EF Core (PostgreSQL) event store and snapshot store for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Projections](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-projections.md): Read-model projections and catch-up subscription host for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Projections.EfCore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-projections-efcore.md): EF Core (PostgreSQL) projection checkpoint store for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Inbox.EfCore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-inbox-efcore.md): EF Core inbox (idempotent consumer) store for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Outbox](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-outbox.md): Core outbox abstractions and implementations for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Outbox.EfCore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-outbox-efcore.md): EF Core (PostgreSQL) transactional outbox for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Messaging](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging.md): Core messaging abstractions and interfaces for Nuvora Nexus
- [Nuvora.Nexus.Relay.Messaging.AmazonSqs](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-amazonsqs.md): Amazon SQS/SNS message transport for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Messaging.AzureServiceBus](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-azureservicebus.md): Azure Service Bus message transport for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Messaging.InMemory](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-inmemory.md): In-memory message transport for Nuvora Nexus Relay. A drop-in replacement for the RabbitMQ transport that runs the full outbox -> broker -> inbox loop in-process, for fast infrastructure-free tests and local development.
- [Nuvora.Nexus.Relay.Messaging.Kafka](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-kafka.md): Apache Kafka message transport for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Messaging.Nats](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-nats.md): NATS JetStream message transport for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Messaging.Nms](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-nms.md): JMS/NMS message transport for Nuvora Nexus Relay (Apache ActiveMQ "classic" and ActiveMQ Artemis)
- [Nuvora.Nexus.Relay.Messaging.Pulsar](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-pulsar.md): Apache Pulsar message transport for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Messaging.RabbitMq](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-rabbitmq.md): RabbitMQ message broker for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Messaging.ValKey](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-messaging-valkey.md): ValKey Streams message transport for Nuvora Nexus Relay (works with any Redis-compatible server)
- [Nuvora.Nexus.Relay.Sagas](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-sagas.md): Sagas / process managers (state-stored, scheduler-backed timeouts) for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Sagas.EfCore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-sagas-efcore.md): EF Core (PostgreSQL) saga store for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Sagas.ValKey](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-sagas-valkey.md): ValKey saga persistence for Nuvora Nexus Relay (works with any Redis-compatible server)
- [Nuvora.Nexus.Relay.Scheduling](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-scheduling.md): Scheduled / delayed message abstractions and processor for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Scheduling.EfCore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-scheduling-efcore.md): EF Core (PostgreSQL) scheduled-message store for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Coordination.ValKey](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-coordination-valkey.md): ValKey-backed distributed coordination for Nuvora Nexus Relay: distributed locks, fenced leases, node registry and wake bridge (works with any Redis-compatible server)
- [Nuvora.Nexus.Relay.Tenancy](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-tenancy.md): Multi-tenancy (resolution, ambient context, enforcement) for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Tenancy.EfCore](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-tenancy-efcore.md): EF Core / PostgreSQL tenant storage strategies (shared-table RLS) for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Auth](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-auth.md): Authentication and authorization module for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Cache](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-cache.md): Core caching abstractions for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Cache.InMemory](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-cache-inmemory.md): In-memory caching strategy for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Cache.Redis](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-cache-redis.md): Redis caching strategy for Nuvora Nexus Relay
- [Nuvora.Nexus.Relay.Diagnostics](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-diagnostics.md): OpenTelemetry registration helpers for Nuvora Nexus Relay instrumentation
- [Nuvora.Nexus.Relay.Management](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-management.md): Management control plane for Nuvora Nexus Relay: ingests node registrations/heartbeats/snapshots, evaluates alerts, pushes live updates over SignalR, and serves the dashboard query API.
- [Nuvora.Nexus.Relay.Management.Agent](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-management-agent.md): In-process agent that registers a Nuvora Nexus Relay service with the management control plane and pushes heartbeats, metrics and subsystem snapshots.
- [Nuvora.Nexus.Relay.Management.Contracts](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-management-contracts.md): Shared wire contracts (registration, heartbeat, snapshots, actions, alerts) for the Nuvora Nexus Relay management control plane and agent.
- [Nuvora.Nexus.Relay.Generators](https://relay.nuvoralabs.com/api/nuvora-nexus-relay-generators.md): Roslyn analyzer for Nuvora Nexus Relay: compile-time checks that command/query types have exactly one handler (RELAY001/RELAY002), and the registration hook for generated handler wiring.

## Articles

### Mediator & CQRS
- [001 — Getting Started: Commands, Queries, and the Mediator](https://relay.nuvoralabs.com/articles/getting-started.md): Relay is a framework for building .NET services around CQRS (Command Query Responsibility Segregation) and an in-process mediator.
- [002 — Your First Aggregate](https://relay.nuvoralabs.com/articles/first-aggregate.md): In Getting Started, the Product was a plain record and the "store" was a dictionary.
- [003 — Domain Events](https://relay.nuvoralabs.com/articles/domain-events.md): In Your First Aggregate, the Order aggregate raised domain events, but they just sat in a list — nothing reacted to them. This article closes that loop.
- [004 — Errors & HTTP](https://relay.nuvoralabs.com/articles/errors-and-http.md): A handler's job is to express what went wrong in business terms — "this payment was not found," "the amount exceeds the limit," "the card was declined" — not to know that those map to HTTP 404, 422, and 402.

### Event Sourcing
- [005 — Event Sourcing Basics](https://relay.nuvoralabs.com/articles/event-sourcing-basics.md): Every sample so far stored state: the current product, the current order, the current balance.
- [006 — Concurrency & Snapshots](https://relay.nuvoralabs.com/articles/concurrency-and-snapshots.md): Event sourcing works beautifully for a fresh account with three events. Production breaks that idyll two ways.
- [024 — Schema Evolution: Upcasters, Stable Names, Migrations](https://relay.nuvoralabs.com/articles/schema-evolution.md): In an event-sourced system the events are the database, and unlike rows you can never UPDATE them — history is immutable.
- [027 — Time-Travel & Live Aggregation: Reading the Past from the Stream](https://relay.nuvoralabs.com/articles/time-travel-and-live-aggregation.md): Event sourcing stores the sequence of events that produced an aggregate's state, and the write side rebuilds the current state by replaying that sequence.
- [028 — Pessimistic Per-Aggregate Write Lock](https://relay.nuvoralabs.com/articles/pessimistic-aggregate-locking.md): Concurrency & Snapshots established Relay's default for concurrent writes to an event-sourced aggregate: optimistic concurrency.
- [029 — Rich Event Metadata](https://relay.nuvoralabs.com/articles/rich-event-metadata.md): Every event Relay appends already carries a little metadata: the CommandName that produced it and a Timestamp.
- [034 — Event Archiving & Compaction](https://relay.nuvoralabs.com/articles/event-archiving-and-compaction.md): An event store is append-only: events are never updated and never deleted, which is exactly what makes it a trustworthy source of truth.
- [035 — Crypto-Shredding for the Right to Erasure](https://relay.nuvoralabs.com/articles/crypto-shredding-right-to-erasure.md): An event-sourced system has a property its operators love and its compliance officers fear: the log is immutable and never deletes.

### Projections & Read Models
- [007 — Projections](https://relay.nuvoralabs.com/articles/projections.md): Event sourcing stores what happened, which is perfect for the write side and useless for the read side.
- [008 — Projection Operations](https://relay.nuvoralabs.com/articles/projection-operations.md): The Projections article's host works while every event is well-behaved. Production guarantees two things that break that assumption.
- [009 — Caching Queries](https://relay.nuvoralabs.com/articles/caching-queries.md): A read model already makes queries fast — a single indexed SELECT.
- [026 — Inline & Multi-Stream Projections](https://relay.nuvoralabs.com/articles/inline-and-multistream-projections.md): The Projections article built the standard read side: a projection runs in a background host, catches up from a checkpoint after each command commits, and is eventually consistent.
- [031 — Intra-Projection Sharding: Parallel Lanes for One Hot Projection](https://relay.nuvoralabs.com/articles/intra-projection-sharding.md): Projection Operations makes a deliberate promise: a projection has exactly one active worker.
- [032 — Automated Blue/Green Projection Rebuilds](https://relay.nuvoralabs.com/articles/automated-blue-green-rebuilds.md): The Projection Operations article gave you the shadow (blue/green) rebuild: a projection implements IRebuildableProjection, IProjectionRebuildManager builds a fresh shadow read model from history while the live one keeps serving, and once the shadow has caught up an operator calls SwapAsync to atomically promote it.
- [033 — Persistent Named Subscriptions](https://relay.nuvoralabs.com/articles/persistent-named-subscriptions.md): A projection is a catch-up reader: it walks the global event log forward, updates a read model, and remembers how far it got so a restart resumes instead of reprocessing two years of history.

### Messaging & Reliability
- [011 — The Outbox Pattern](https://relay.nuvoralabs.com/articles/outbox.md): A command often needs to do two things: change its own state (save the order) and tell other services about it (publish OrderPlaced).
- [012 — Messaging & Transports](https://relay.nuvoralabs.com/articles/messaging-and-transports.md): The outbox stages events; a transport carries them.
- [013 — The Inbox Pattern](https://relay.nuvoralabs.com/articles/inbox.md): The outbox guarantees at-least-once delivery — which means the same message can arrive twice (a broker redelivery, an outbox re-publish after a crash).
- [014 — Reliable Messaging (End to End)](https://relay.nuvoralabs.com/articles/reliable-messaging.md): The previous three articles built the pieces; this one assembles them into the complete, reliable, cross-service flow:

### Sagas & Workflows
- [015 — Sagas](https://relay.nuvoralabs.com/articles/sagas.md): A command changes one aggregate; reliable messaging lets services react to each other.
- [016 — State-Machine Sagas](https://relay.nuvoralabs.com/articles/state-machine-sagas.md): The Sagas article authored a saga imperatively — handler methods that mutate state and call RequestTimeout/Complete.
- [017 — Routing Slips & Compensation](https://relay.nuvoralabs.com/articles/routing-slips.md): A distributed process books a flight, a hotel, and a car across three services. The flight and hotel succeed; the car fails.
- [036 — Standalone Courier Activities](https://relay.nuvoralabs.com/articles/standalone-courier-activities.md): Routing Slips & Compensation showed compensation inside a saga: forward legs record undo-commands onto a durable itinerary, and a failure replays them in reverse as reliable, scheduled commands.

### Scheduling & Time
- [018 — Scheduling](https://relay.nuvoralabs.com/articles/scheduling.md): Some work shouldn't happen now — it should happen later: send a reminder in 30 minutes, expire an unpaid order in an hour, retry a failed call after a backoff.
- [019 — Recurring Jobs](https://relay.nuvoralabs.com/articles/recurring-jobs.md): The Scheduling article covered one-shot future work. This article covers the recurring case — "every night at 2am," "every Monday," "every 15 minutes" — and the job as the unit of recurring/background work.

### Tenancy & Security
- [010 — Authorization](https://relay.nuvoralabs.com/articles/authorization.md): Authorization in Relay is declared on the message, not the endpoint.
- [020 — Multi-Tenancy: Resolution, Enforcement, Isolation](https://relay.nuvoralabs.com/articles/multi-tenancy.md): A multi-tenant service serves many customers (tenants) from shared infrastructure while guaranteeing that one tenant can never see another's data.

### Production Operations
- [021 — Observability: Telemetry, Metrics, Tracing, Health](https://relay.nuvoralabs.com/articles/observability.md): You cannot operate what you cannot see. Relay is instrumented with OpenTelemetry-native primitives out of the box — no wrappers, no proprietary format.
- [022 — Resiliency: Retries, Circuit Breakers, Rate & Concurrency Limits](https://relay.nuvoralabs.com/articles/resiliency.md): Distributed systems fail in partial, transient ways: a database blips, a downstream API times out, a queue backs up.
- [023 — Distributed Coordination: Locks, Leader Election, Partitioning](https://relay.nuvoralabs.com/articles/distributed-coordination.md): You scale a service by running more copies of it — but now those copies can step on each other: two instances run the same nightly job, or both try to advance the same projection, or process the same key out of order.
- [025 — Reference Architecture: A Production Service End-to-End](https://relay.nuvoralabs.com/articles/reference-architecture.md): The previous twenty-four articles each isolated one capability.
- [030 — Fenced Leadership & Cluster Membership](https://relay.nuvoralabs.com/articles/fenced-leadership-and-membership.md): The Distributed Coordination article elects a leader the simple way: a connection-bound ILeaderElector holds a PostgreSQL advisory lock for as long as its connection lives, and the database drops that lock when the process dies.
- [037 — Operational Event Queries: A Forensic Scan over the Log](https://relay.nuvoralabs.com/articles/operational-event-queries.md): The event store is an append-only log, and Event Sourcing Basics is emphatic about the rule that follows from that: never query the event store for reads.
- [038 — Telemetry Segmentation: Per-Tenant & Per-Dimension Metrics](https://relay.nuvoralabs.com/articles/telemetry-segmentation.md): Relay's command/query metrics are tagged by message type out of the box — relay.commands.executed and relay.queries.executed carry a command/query name plus success, and a matching duration histogram.

## Stories

### Pemberton & Crumb — A tiny retailer, an improbable success, and a codebase quietly turning to soup.
- [001 — The Spreadsheet That Ran the Warehouse](https://relay.nuvoralabs.com/stories/the-spreadsheet-that-ran-the-warehouse.md): Every feature takes longer than the last; the code has turned to soup
- [002 — The Case of the Missing $4,000](https://relay.nuvoralabs.com/stories/the-case-of-the-missing-4000.md): A balance is wrong and nobody can say why — there's no history
- [003 — The Payment That Published But Never Happened](https://relay.nuvoralabs.com/stories/the-payment-that-published-but-never-happened.md): The database saved it but the message never sent — or vice versa
- [004 — The Email That Sent Itself Five Times](https://relay.nuvoralabs.com/stories/the-email-that-sent-itself-five-times.md): One event, delivered twice, charged the customer twice
- [005 — The Black Friday That Melted](https://relay.nuvoralabs.com/stories/the-black-friday-that-melted.md): One slow dependency took down everything, then the retries finished the job
- [006 — The 2 A.M. Page Nobody Could Read](https://relay.nuvoralabs.com/stories/the-2am-page-nobody-could-read.md): Something's broken, the dashboard is green, and nobody can find the request
- [007 — The Tenant Who Saw Someone Else's Data](https://relay.nuvoralabs.com/stories/the-tenant-who-saw-someone-elses-data.md): One forgotten WHERE clause became a customer-facing breach
- [008 — The Order That Got Stuck Forever](https://relay.nuvoralabs.com/stories/the-order-that-got-stuck-forever.md): A five-step process died on step three and left money in limbo
- [009 — The Auth Check Everyone Forgot](https://relay.nuvoralabs.com/stories/the-auth-check-everyone-forgot.md): An endpoint shipped wide open, and the code review didn't catch it
- [010 — How a Tiny Team Shipped Like a Big One](https://relay.nuvoralabs.com/stories/how-a-tiny-team-shipped-like-a-big-one.md): The payoff: five people, big-system guarantees, no army required

### Frontrow — A ticketing startup goes viral and learns about scale the hard way.
- [011 — The Two People Who Bought the Last Seat](https://relay.nuvoralabs.com/stories/the-two-people-who-bought-the-last-seat.md): Two buyers, one seat, a race condition in correct-looking code
- [012 — The Ticket Page That Hugged the Database to Death](https://relay.nuvoralabs.com/stories/the-ticket-page-that-hugged-the-database-to-death.md): Going viral became an outage; lookers crowded out buyers
- [013 — The Reminder That Arrived a Day Late](https://relay.nuvoralabs.com/stories/the-reminder-that-arrived-a-day-late.md): A scan-and-send loop sent duplicates, gaps, and 3 a.m. emails
- [014 — The Nightly Job That Quietly Stopped](https://relay.nuvoralabs.com/stories/the-nightly-job-that-quietly-stopped.md): A cron job on one box died silently and lost two weeks of books
- [015 — The Payout That Ran Twice](https://relay.nuvoralabs.com/stories/the-payout-that-ran-twice.md): Redundancy without coordination paid every venue six times
- [016 — The Read Model That Lied](https://relay.nuvoralabs.com/stories/the-read-model-that-lied.md): A fixed bug's wrong numbers were stuck in the dashboard forever
- [017 — The Field We Forgot to Add](https://relay.nuvoralabs.com/stories/the-field-we-forgot-to-add.md): New code couldn't read three years of old, immutable events
- [018 — The Customer Who Asked to Be Forgotten](https://relay.nuvoralabs.com/stories/the-customer-who-asked-to-be-forgotten.md): An immutable log met the legal right to be erased
- [019 — The Partner Who Spoke a Different Language](https://relay.nuvoralabs.com/stories/the-partner-who-spoke-a-different-language.md): Every new partner ran a different message broker
- [020 — Who Did This, and When?](https://relay.nuvoralabs.com/stories/who-did-this-and-when.md): The payoff: 5,000 mystery refunds, answered precisely from the log

### Magpie — A money app grows up the careful way — and learns to account for its own past.
- [021 — The Account That Went Negative](https://relay.nuvoralabs.com/stories/the-account-that-went-negative.md): The "impossible" balance, because the rules lived in the UI, not the model
- [022 — The Five Things That Should Happen When Money Moves](https://relay.nuvoralabs.com/stories/the-five-things-that-should-happen-when-money-moves.md): One action did five jobs inline; a broken email stopped a deposit
- [023 — The 500 That Leaked the Stack Trace](https://relay.nuvoralabs.com/stories/the-500-that-leaked-the-stack-trace.md): Inconsistent errors, leaked internals, and a partner who couldn't integrate
- [024 — The Onboarding That Got Lost in If-Statements](https://relay.nuvoralabs.com/stories/the-onboarding-that-got-lost-in-if-statements.md): A workflow modeled as flag-soup, with impossible states in production
- [025 — The Transfer That Needed Undoing](https://relay.nuvoralabs.com/stories/the-transfer-that-needed-undoing.md): A folder of one-off "undo money" scripts, none of them auditable
- [026 — The Customer View That Was Always a Bit Wrong](https://relay.nuvoralabs.com/stories/the-customer-view-that-was-always-a-bit-wrong.md): Stale-after-write reads and an incoherent multi-source dashboard
- [027 — The Transaction Feed That Fell Behind](https://relay.nuvoralabs.com/stories/the-transaction-feed-that-fell-behind.md): One sequential projection couldn't keep up on payday
- [028 — The Fraud Team Who Showed Up Late](https://relay.nuvoralabs.com/stories/the-fraud-team-who-showed-up-late.md): A new consumer needed all of history, then live — without losing its place
- [029 — The Log That Ate the Storage Budget](https://relay.nuvoralabs.com/stories/the-log-that-ate-the-storage-budget.md): Keeping everything forever became the biggest line item
- [030 — What Did My Balance Say Last Tuesday?](https://relay.nuvoralabs.com/stories/what-did-my-balance-say-last-tuesday.md): The payoff: customer, regulator, and lawyer all ask about the past — and get answers
