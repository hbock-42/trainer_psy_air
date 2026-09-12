# Schemas moved

The content JSON Schemas moved to [`packages/psy_content/schema/`](../../../packages/psy_content/schema/)
as part of US-007 (monorepo layout). Update the `$schema` pointer in new
content files accordingly, e.g.:

```jsonc
"$schema": "../../../../packages/psy_content/schema/item.schema.json"
```

See [`docs/content/AUTHORING.md`](../AUTHORING.md) for the authoring guide.
