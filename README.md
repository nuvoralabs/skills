# Nuvora Labs — Claude Code skills

Skills that teach Claude Code to work on the [Nuvora Nexus](https://github.com/nuvoralabs)
platform. Each one routes to the product's own documentation site and reads the
current Markdown pages, so guidance tracks the docs instead of drifting away from
them.

| Skill | Covers | Docs |
|---|---|---|
| `nuvora-relay` | DDD / CQRS / event sourcing — commands and handlers, aggregates, the event store, projections, outbox/inbox, sagas, scheduling, tenancy, observability | [relay.nuvoralabs.com](https://relay.nuvoralabs.com) |
| `nuvora-sentinel` | Identity, authentication and authorization — passkeys and MFA, the permission grammar, OIDC, SAML, SCIM, multi-org, machine identity, audit, compliance | [sentinel.nuvoralabs.com](https://sentinel.nuvoralabs.com) |

## Install

### As plugins (recommended)

```
/plugin marketplace add nuvoralabs/skills
/plugin install nuvora-relay@nuvoralabs
/plugin install nuvora-sentinel@nuvoralabs
```

### By copying the skill folder

Drop a skill into `.claude/skills/` in a project, or `~/.claude/skills/` to have it
everywhere:

```bash
git clone https://github.com/nuvoralabs/skills.git /tmp/nuvora-skills
cp -R /tmp/nuvora-skills/relay/skills/nuvora-relay ~/.claude/skills/
cp -R /tmp/nuvora-skills/sentinel/skills/nuvora-sentinel ~/.claude/skills/
```

Either way, Claude loads a skill on its own when the work matches its description —
no command to remember. You can also ask for one by name.

## How they stay current

Both products publish [llms.txt](https://llmstxt.org): a machine-readable index of
every page, each available as clean Markdown at its `.md` URL.

A skill therefore carries **judgement, not a copy of the docs** — the wiring order
that matters, the fail-closed defaults you must not weaken, which page answers which
question — and fetches the actual API surface at the moment it is needed. Each skill
ships `scripts/fetch-docs.sh`, a small cached fetcher over that index:

```bash
scripts/fetch-docs.sh get docs/event-sourcing articles/outbox
scripts/fetch-docs.sh search projection rebuild
scripts/fetch-docs.sh api Nuvora.Nexus.Relay.Sagas
scripts/fetch-docs.sh index
```

Responses are cached for six hours under `$TMPDIR`. Requests are plain unauthenticated
`GET`s to the public documentation sites; nothing from your codebase is sent anywhere.

## Layout

```
.claude-plugin/marketplace.json     the marketplace both plugins are listed in
relay/
  .claude-plugin/plugin.json
  skills/nuvora-relay/
    SKILL.md                        capability routing table + working conventions
    references/doc-map.md           snapshot of the site index
    scripts/fetch-docs.sh           cached Markdown fetcher
sentinel/
  .claude-plugin/plugin.json
  skills/nuvora-sentinel/           same shape
```

## Contributing

Keep `SKILL.md` about things the docs cannot say for themselves — ordering
constraints, fail-closed defaults, the pitfall that costs an afternoon. Anything that
is simply *what the API is* belongs on the documentation site, where the skill will
find it.

`references/doc-map.md` is generated from the live index and is safe to regenerate:

```bash
scripts/fetch-docs.sh clean && scripts/fetch-docs.sh index
```

MIT licensed.
