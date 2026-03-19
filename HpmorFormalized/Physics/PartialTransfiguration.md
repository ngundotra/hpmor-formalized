# Partial Transfiguration: Mereology vs. Field Ontology

**HPMOR Chapters**: 28-29
**Lean file**: `HpmorFormalized/Physics/PartialTransfiguration.lean`
**Status**: All theorems compile, no `sorry`

## HPMOR Claim

Standard wizards can transfigure whole objects but not parts. Harry discovers partial transfiguration by adopting a quantum-field-theory view: matter is not discrete objects with boundaries but continuous fields defined at every point. The narrative claims you must abandon object-level ontology for field-based ontology.

## Prediction

The formalization should reveal that partial transfiguration doesn't require abandoning objects for fields -- it requires adopting a mereology where arbitrary fusions exist (unrestricted composition). Harry's insight is correct in spirit but wrong about the mechanism.

## What Was Formalized

### Three Ontologies

| Ontology | Model | Partial Transfig? |
|----------|-------|-------------------|
| Object (S1) | Finite set of atomic objects, no internal structure | **No** -- atoms have no proper parts |
| Field (S2) | Function `Point -> Material` | **Yes** -- restrict to any subregion |
| Mereological (S3) | Partial order with parthood relation | **Yes, if unrestricted composition holds** |

### Key Theorems

1. **`object_no_partial_transfig`**: In object ontology, each object's only part is itself.
2. **`object_partial_is_whole_or_nothing`**: Any "partial" transfiguration in object ontology either changes all of an object or none of it.
3. **`field_partial_transfig`**: In field ontology, partial transfiguration is well-defined for any predicate (region).
4. **`mereological_partial_transfig`**: In mereological ontology, partial transfiguration is well-defined for any part that exists in the structure.
5. **`unrestricted_enables_arbitrary_partial`**: With unrestricted composition, ANY collection of parts of a whole forms a valid transfiguration target.
6. **`restricted_composition_blocks_some_partials`**: Without unrestricted composition, some collections of parts lack a fusion, blocking partial transfiguration.
7. **`field_ontology_embeds_in_mereology`**: Field ontology is a special case of mereological ontology (power set with set union as fusion).
8. **`harry_doesnt_need_qft`**: Constructs a finite, 3-element, non-powerset partial order with unrestricted composition -- a discrete non-field structure supporting partial transfiguration.

## Findings (Tier 3)

**The prediction is confirmed.**

### The Real Dichotomy

HPMOR presents: **objects** (no parts) vs. **fields** (arbitrary parts).

The formalization reveals: **restricted composition** (only designated wholes are valid targets) vs. **unrestricted composition** (any collection of parts is a valid target).

### Why Harry Doesn't Need QFT

Harry's move from "discrete objects" to "continuous fields" works because field theory *implicitly* provides unrestricted composition: any subregion of a field is a valid entity. But `harry_doesnt_need_qft` constructs a finite, discrete structure (Fin 3 with its linear order) that also has unrestricted composition. No points, no continuity, no fields -- just three abstract entities with a parthood relation where every nonempty subset has a maximum.

A wizard who understood mereology -- specifically, the axiom of unrestricted composition ("any collection of parts forms a whole") -- could achieve partial transfiguration without any knowledge of quantum field theory.

### Connection to Philosophy

This connects to a real debate in analytic metaphysics. The axiom of unrestricted composition (also called "universalism" in mereology) says that any objects whatsoever compose a further object. This is controversial in philosophy (does a random electron in Alpha Centauri and my left shoe compose an object?) but is exactly what you need for arbitrary partial transfiguration.

Harry's insight maps onto: "adopt unrestricted composition." His mistake is thinking this requires physics (QFT) when it only requires metaphysics (mereological universalism).
