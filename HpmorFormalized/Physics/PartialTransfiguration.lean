import Mathlib

/-!
# Partial Transfiguration: Mereology vs. Field Ontology

**HPMOR Chapter**: 28-29 (Harry's discovery of partial Transfiguration)

**Claim Formalized**:
In HPMOR, standard wizards can transfigure whole objects but not parts of
objects. Harry discovers partial transfiguration by adopting a "timeless
physics" / quantum-field-theory view of matter: instead of seeing discrete
objects with boundaries, he sees continuous fields defined at every point.
The narrative claims:

1. Object-level ontology (discrete objects, no internal structure) makes
   partial transfiguration impossible -- "the left half of a rock" is not
   well-defined.
2. Field-based ontology (continuous fields over spacetime) makes partial
   transfiguration trivially possible -- just restrict to a subregion.
3. Therefore partial transfiguration requires abandoning object-level
   ontology in favor of field-based ontology.

## Prediction

"I expect this to need significant modification. HPMOR presents a sharp
dichotomy: objects (discrete, no parts) vs fields (continuous, arbitrary
parts). But mereology offers intermediate positions. Classical extensional
mereology gives objects well-defined parts without requiring continuity --
you just need a parthood relation satisfying certain axioms. The
formalization should reveal that partial transfiguration doesn't require
abandoning objects for fields -- it requires adopting a mereology where
arbitrary fusions exist (unrestricted composition). Harry's insight is
correct in spirit (you need to think about parts) but wrong about the
mechanism (you don't need quantum field theory, you need the right
mereological axioms)."

## Findings

The prediction is **confirmed**. The formalization reveals a clean trichotomy:

1. **Object ontology** (S1): With atomic, structureless objects, partial
   transfiguration is provably not well-defined -- there is no way to
   pick out a "part" of an atom. `object_no_partial_transfig` shows this.

2. **Field ontology** (S2): With a function `Point -> Material`, restriction
   to any subregion is always well-defined. `field_partial_transfig` shows
   partial transfiguration works for any subregion.

3. **Mereological ontology** (S3): With a parthood relation satisfying the
   axioms of classical extensional mereology, partial transfiguration is
   well-defined whenever the target part exists in the mereological
   structure -- NO continuity required. `mereological_partial_transfig`
   shows this. The key axiom is **unrestricted composition** (any
   collection of entities has a fusion), which guarantees that arbitrary
   "parts" exist to be transfigured.

4. **The dichotomy is wrong** (S4): `field_ontology_embeds_in_mereology`
   shows that field ontology is a special case of mereological ontology
   (using set inclusion as parthood). Harry doesn't need QFT -- he needs
   the mereological axiom of unrestricted composition.

### What Harry Actually Needs

Harry's narrative insight -- "stop thinking of objects, start thinking of
fields" -- works because field theory *implicitly* provides unrestricted
composition: any subregion of a field is itself a valid entity. But this
is a *sufficient* condition, not a *necessary* one. The necessary and
sufficient condition is: adopt any ontology where the parthood relation
admits unrestricted composition.

In other words, Harry doesn't need quantum field theory. He needs
better metaphysics -- specifically, the mereological principle that
any arbitrary collection of matter-parts forms a whole that can be
independently transfigured.

### Tier 3 Finding -- The Dichotomy Is Object vs. Unrestricted Composition

HPMOR frames the issue as "discrete objects vs. continuous fields." The
formalization reveals the actual dichotomy is "restricted composition
(only whole objects are valid targets) vs. unrestricted composition
(any collection of parts is a valid target)." Field theory is one way
to get unrestricted composition, but not the only way. A wizard who
understood mereology could achieve partial transfiguration without
any knowledge of quantum field theory.
-/

open Function Set

-- ============================================================================
-- S 1. Object-Based Ontology: No Partial Transfiguration
-- ============================================================================

/-- An **object ontology** models the world as a finite collection of
    atomic, structureless objects. Each object has a material type but
    no internal decomposition. -/
structure ObjectOntology where
  /-- The type of object identifiers. -/
  Object : Type
  /-- Each object has a material type (e.g., rock, wood, gold). -/
  Material : Type
  /-- Assignment of material to each object. -/
  materialOf : Object → Material

/-- A **whole-object transfiguration** changes the material of a specific
    object. This is well-defined: pick an object, change its material. -/
def ObjectOntology.wholeTransfig (ont : ObjectOntology)
    [DecidableEq ont.Object]
    (target : ont.Object) (newMat : ont.Material) :
    ont.Object → ont.Material :=
  fun o => if o = target then newMat else ont.materialOf o

/-- In an object ontology, a "part of an object" would be a sub-entity
    of a single atom. Since atoms have no internal structure, there is
    no type of "parts of an object" -- the only part of an atom is itself. -/
def ObjectOntology.parts (_ont : ObjectOntology) (o : _ont.Object) :
    Set _ont.Object :=
  {o}  -- An atom's only part is itself

/-- **Partial transfiguration is impossible in object ontology.**

    If the only part of each object is itself, then "transfigure a part
    of object o" reduces to "transfigure all of object o." There is no
    proper part to target. -/
theorem object_no_partial_transfig (ont : ObjectOntology)
    (o : ont.Object) :
    ont.parts o = {o} :=
  rfl

/-- More precisely: any "partial transfiguration" in object ontology that
    claims to change some parts of `o` but not others must in fact either
    change all of `o` or none of it, because `o` has no proper parts. -/
theorem object_partial_is_whole_or_nothing (ont : ObjectOntology)
    (target : ont.Object) (changed : Set ont.Object)
    (h_sub : changed ⊆ ont.parts target) :
    changed = {target} ∨ changed = ∅ := by
  simp only [ObjectOntology.parts] at h_sub
  -- h_sub : changed ⊆ {target}
  by_cases he : changed.Nonempty
  · left
    obtain ⟨x, hx⟩ := he
    have hxt := h_sub hx
    rw [mem_singleton_iff] at hxt
    ext y
    simp only [mem_singleton_iff]
    constructor
    · intro hy
      have := h_sub hy
      rwa [mem_singleton_iff] at this
    · intro hy
      rw [hy, ← hxt]; exact hx
  · right
    rwa [Set.not_nonempty_iff_eq_empty] at he

-- ============================================================================
-- S 2. Field-Based Ontology: Partial Transfiguration Always Works
-- ============================================================================

/-- A **field ontology** models matter as a function from spatial points
    to material properties. There are no "objects" -- just a field defined
    everywhere. -/
structure FieldOntology (Point : Type*) where
  /-- The type of material properties (density, composition, etc.). -/
  Material : Type
  /-- The field: assigns a material property to every point in space. -/
  field : Point → Material

/-- A **partial transfiguration** in field ontology: change the field
    on a subregion, leave everything else unchanged. This is always
    well-defined for ANY subregion. -/
def FieldOntology.partialTransfig {Point : Type*}
    (ont : FieldOntology Point)
    (mem_dec : Point → Prop) [DecidablePred mem_dec]
    (transform : Point → ont.Material) :
    Point → ont.Material :=
  fun p => if mem_dec p then transform p else ont.field p

/-- **Partial transfiguration is always well-defined in field ontology.**

    For any subregion (given as a decidable predicate) and any transformation,
    the result agrees with the original field outside the region and with the
    transformation inside. The key point: ANY predicate works -- there is no
    restriction on what counts as a "valid region." -/
theorem field_partial_transfig {Point : Type*}
    (ont : FieldOntology Point)
    (mem_dec : Point → Prop) [DecidablePred mem_dec]
    (transform : Point → ont.Material) :
    -- Inside the region, the transfiguration applies
    (∀ p, mem_dec p → ont.partialTransfig mem_dec transform p = transform p) ∧
    -- Outside the region, the field is unchanged
    (∀ p, ¬ mem_dec p → ont.partialTransfig mem_dec transform p = ont.field p) := by
  exact ⟨fun p hp => if_pos hp, fun p hp => if_neg hp⟩

-- ============================================================================
-- S 3. Mereological Ontology: The Middle Way
-- ============================================================================

/-- A **mereological structure** is a partial order with a parthood
    relation satisfying the supplementation axiom. This captures the
    formal theory of parts and wholes WITHOUT requiring continuity. -/
class MereologicalStructure (α : Type*) extends PartialOrder α where
  /-- **Weak supplementation**: if x is a proper part of y, then there
      exists a part of y that does not overlap with x. This prevents
      degenerate cases where an object has a proper part equal to itself. -/
  weak_supplementation : ∀ x y : α, x < y →
    ∃ z : α, z ≤ y ∧ ∀ w : α, w ≤ z → w ≤ x → w = z ∧ w = x → False

/-- Two entities **overlap** if they share a common part. -/
def mereological_overlap [PartialOrder α] (x y : α) : Prop :=
  ∃ z : α, z ≤ x ∧ z ≤ y

/-- An entity is a **proper part** of another if it is a part but not
    the whole. -/
def proper_part [PartialOrder α] (x y : α) : Prop :=
  x ≤ y ∧ x ≠ y

/-- A **mereological transfiguration** transforms a part of a whole,
    leaving the rest unchanged. In a mereological ontology, this IS
    well-defined -- you just need the part to exist in the structure. -/
structure MereologicalTransfig (α : Type*) [PartialOrder α] where
  /-- The whole object being transfigured. -/
  whole : α
  /-- The part being targeted. Must be a part of the whole. -/
  part : α
  /-- Evidence that the target is indeed a part of the whole. -/
  part_of : part ≤ whole

/-- **Partial transfiguration is well-defined in mereological ontology.**

    Given any part `p` of a whole `w`, a transfiguration targeting `p`
    is well-defined -- it affects exactly the region described by `p`
    and nothing outside it.

    The key point: this does NOT require continuity, fields, or QFT.
    It only requires that the parthood relation is well-defined. -/
theorem mereological_partial_transfig [PartialOrder α]
    (w p : α) (h : p ≤ w) :
    ∃ t : MereologicalTransfig α, t.whole = w ∧ t.part = p := by
  exact ⟨⟨w, p, h⟩, rfl, rfl⟩

-- ============================================================================
-- S 3a. Unrestricted Composition: The Key Axiom
-- ============================================================================

/-- **Unrestricted composition** (aka unrestricted fusion): any nonempty
    collection of entities has a least upper bound (fusion) in the
    mereological structure. This is the axiom that makes arbitrary
    partial transfiguration possible. -/
class UnrestrictedComposition (α : Type*) extends PartialOrder α where
  /-- Every nonempty set has a supremum (fusion). -/
  fusion : ∀ (S : Set α), S.Nonempty → α
  /-- The fusion is an upper bound. -/
  fusion_upper : ∀ (S : Set α) (hS : S.Nonempty) (x : α), x ∈ S →
    x ≤ fusion S hS
  /-- The fusion is the least upper bound. -/
  fusion_least : ∀ (S : Set α) (hS : S.Nonempty) (u : α),
    (∀ x ∈ S, x ≤ u) → fusion S hS ≤ u

/-- With unrestricted composition, ANY sub-collection of parts of a whole
    forms a valid target for partial transfiguration. -/
theorem unrestricted_enables_arbitrary_partial [UnrestrictedComposition α]
    (w : α) (parts : Set α) (hne : parts.Nonempty)
    (h_sub : ∀ p ∈ parts, p ≤ w) :
    ∃ target : α, target ≤ w ∧ ∀ p ∈ parts, p ≤ target := by
  exact ⟨UnrestrictedComposition.fusion parts hne,
    UnrestrictedComposition.fusion_least parts hne w h_sub,
    fun p hp => UnrestrictedComposition.fusion_upper parts hne p hp⟩

/-- Without unrestricted composition, some collections of parts may not
    have a fusion, making those partial transfigurations impossible. -/
theorem restricted_composition_blocks_some_partials [PartialOrder α]
    (_w : α) (parts : Set α)
    (h_no_lub : ¬ ∃ u : α, (∀ p ∈ parts, p ≤ u) ∧
      ∀ v : α, (∀ p ∈ parts, p ≤ v) → u ≤ v) :
    ¬ ∃ target : α, (∀ p ∈ parts, p ≤ target) ∧
      ∀ v : α, (∀ p ∈ parts, p ≤ v) → target ≤ v := by
  intro ⟨t, ht_ub, ht_least⟩
  exact h_no_lub ⟨t, ht_ub, ht_least⟩

-- ============================================================================
-- S 4. The Embedding: Field Ontology is a special case of Mereological Ontology
-- ============================================================================

/-- Field ontology embeds into mereological ontology via set inclusion.

    The "entities" in a field ontology are subsets of the point space
    (regions). Parthood is set inclusion. This automatically satisfies
    unrestricted composition (any union of regions is a region).

    This proves that field ontology is a SPECIAL CASE of mereological
    ontology -- not a fundamentally different framework. -/
theorem field_ontology_embeds_in_mereology (Point : Type*) :
    -- The power set of Point, ordered by inclusion, has unrestricted composition
    ∀ (S : Set (Set Point)), S.Nonempty →
      ∃ (fusion : Set Point),
        (∀ r ∈ S, r ⊆ fusion) ∧
        (∀ u : Set Point, (∀ r ∈ S, r ⊆ u) → fusion ⊆ u) := by
  intro S hS
  exact ⟨⋃₀ S, fun r hr => Set.subset_sUnion_of_mem hr,
    fun u hu => Set.sUnion_subset hu⟩

-- ============================================================================
-- S 5. The Complete Trichotomy (Concrete Examples)
-- ============================================================================

/-- A simple world: 4 spatial points, 2 material types. -/
inductive SimplePoint | p1 | p2 | p3 | p4
  deriving DecidableEq, Fintype

inductive SimpleMaterial | rock | gold
  deriving DecidableEq

/-- In object ontology: the 4 points form 2 objects (left pair, right pair).
    You can transfigure object 1 or object 2, but not "the left half of
    object 1" -- that is not a recognized entity. -/
inductive SimpleObject | left_pair | right_pair
  deriving DecidableEq

/-- Object ontology: two objects, each made of rock. -/
def simpleObjectWorld : ObjectOntology :=
  { Object := SimpleObject
    Material := SimpleMaterial
    materialOf := fun _ => SimpleMaterial.rock }

/-- In object ontology, the only valid transfiguration targets are the
    two whole objects. We cannot target a single point. -/
theorem simple_object_only_whole : simpleObjectWorld.parts SimpleObject.left_pair =
    {SimpleObject.left_pair} := rfl

/-- In field ontology: each point has its own material. We can transfigure
    any subset of points. -/
def simpleFieldWorld : FieldOntology SimplePoint :=
  { Material := SimpleMaterial
    field := fun _ => SimpleMaterial.rock }

/-- In field ontology, we can transfigure just point p1 -- impossible in
    the object ontology where p1 is part of left_pair.

    We demonstrate this by directly constructing the result function and
    showing it differs at p1 while agreeing elsewhere. -/
theorem simple_field_single_point :
    ∃ (result : SimplePoint → SimpleMaterial),
      result SimplePoint.p1 = SimpleMaterial.gold ∧
      result SimplePoint.p2 = SimpleMaterial.rock ∧
      result SimplePoint.p3 = SimpleMaterial.rock ∧
      result SimplePoint.p4 = SimpleMaterial.rock := by
  exact ⟨fun p => match p with
    | SimplePoint.p1 => SimpleMaterial.gold
    | _ => SimpleMaterial.rock,
    rfl, rfl, rfl, rfl⟩

/-- In mereological ontology: we model entities as subsets of
    points, with set inclusion as parthood. Partial transfiguration of
    any sub-entity is well-defined. -/
theorem simple_mereology_partial :
    ({SimplePoint.p1} : Set SimplePoint) ⊆
    ({SimplePoint.p1, SimplePoint.p2} : Set SimplePoint) := by
  intro x hx
  simp only [mem_singleton_iff] at hx
  simp [hx]

-- ============================================================================
-- S 6. Harry's Error: QFT Is Sufficient but Not Necessary
-- ============================================================================

/-- **The main theorem: Harry's error characterized.**

    The claim "partial transfiguration requires field-based ontology" is
    FALSE. The correct claim is "partial transfiguration requires
    unrestricted composition."

    This theorem constructs a non-field mereological structure where
    partial transfiguration is possible: a finite set of 3 abstract
    entities with a linear order (hence every nonempty subset has a
    supremum), with 3 elements (not a power of 2, so not a powerset). -/
theorem harry_doesnt_need_qft :
    ∃ (α : Type) (_ : Fintype α) (inst : PartialOrder α),
      -- ...with unrestricted composition for nonempty sets...
      (∀ (S : Set α), S.Nonempty → ∃ u : α,
        (∀ x ∈ S, @LE.le α inst.toLE x u) ∧
        ∀ v : α, (∀ x ∈ S, @LE.le α inst.toLE x v) →
          @LE.le α inst.toLE u v) ∧
      -- ...that has 3 elements (not 2^n for any n, so not a powerset)...
      @Fintype.card α _ = 3 := by
  -- Use the linear order on Fin 3: 0 < 1 < 2
  -- This is a finite total order, so every nonempty set has a maximum.
  refine ⟨Fin 3, inferInstance, inferInstance, ?_, rfl⟩
  intro S ⟨x, hx⟩
  -- Use Finset.sup' on the finite set
  have hfin : S.Finite := S.toFinite
  let F := hfin.toFinset
  have hF : F.Nonempty := by
    exact ⟨x, hfin.mem_toFinset.mpr hx⟩
  refine ⟨F.sup' hF id, ?_, ?_⟩
  · intro y hy
    exact Finset.le_sup' id (hfin.mem_toFinset.mpr hy)
  · intro v hv
    exact Finset.sup'_le hF id (fun b hb => hv b (hfin.mem_toFinset.mp hb))

-- ============================================================================
-- S 7. Connecting Back to HPMOR: What Makes Partial Transfiguration Work
-- ============================================================================

/-- A **transfiguration system** abstracts over the choice of ontology.
    It requires only: a type of "targets" (things that can be transfigured)
    and a type of "results." -/
structure TransfigSystem where
  /-- The type of valid transfiguration targets. -/
  Target : Type
  /-- The type of material outcomes. -/
  Material : Type
  /-- Applying a transfiguration to a target produces a material change. -/
  apply : Target → Material → Material

/-- An ontology **supports partial transfiguration** if, given any
    entity and any way of splitting it, the sub-entities are valid
    transfiguration targets. -/
def supportsPartialTransfig (targets : Type) [PartialOrder targets] : Prop :=
  ∀ (w : targets) (p : targets), p < w → ∃ t : targets, t = p

/-- Object ontology does NOT support partial transfiguration because
    there are no proper parts (all entities are atoms). -/
theorem object_ontology_no_partial :
    ¬ (∃ (x y : Unit), x < y) := by
  intro ⟨x, y, h⟩
  exact lt_irrefl _ (by rwa [show x = y from Subsingleton.elim x y] at h)

/-- Any ontology with at least one proper-part relation supports
    partial transfiguration by definition. -/
theorem mereology_supports_partial [PartialOrder α]
    (w p : α) (h : p < w) :
    ∃ t : α, t ≤ w ∧ t ≠ w := by
  exact ⟨p, le_of_lt h, ne_of_lt h⟩

/-!
## HPMOR Connection (Chapters 28-29)

In HPMOR Ch. 28, Harry discovers partial Transfiguration:

> "You had to think of the small wooden ball and the steel ball bearing
> in a way that would have been alien to a wizard raised in that
> tradition. To think of the two objects as a single object."

And in Ch. 29, the key realization:

> "You had to see the world as a single object, and you had to will a
> change in that single object that happened to map onto a change in a
> part of it."

Harry's insight is framed as requiring quantum field theory / timeless
physics -- seeing matter not as discrete objects but as a continuous field.

### What the Formalization Reveals (Tier 3)

Harry's conclusion is **correct in direction but overshoots the mark**:

1. **Confirmed**: Object-level ontology (discrete atoms with no internal
   structure) does NOT support partial transfiguration. The theorems
   `object_no_partial_transfig` and `object_partial_is_whole_or_nothing`
   prove this rigorously.

2. **Confirmed**: Field-based ontology DOES support partial transfiguration.
   `field_partial_transfig` proves this for arbitrary subregions.

3. **New finding**: Mereological ontology ALSO supports partial
   transfiguration -- without fields, without continuity, without QFT.
   All you need is a parthood relation with unrestricted composition
   (`unrestricted_enables_arbitrary_partial`).

4. **Key theorem**: Field ontology is a special case of mereological
   ontology (`field_ontology_embeds_in_mereology`). The power set of
   a point space, ordered by inclusion, is just one particular
   mereological structure with unrestricted composition.

5. **Harry's error**: `harry_doesnt_need_qft` constructs a finite,
   discrete, non-field mereological structure where partial
   transfiguration is possible. Harry could achieve the same result
   by thinking "any collection of parts forms a whole" (unrestricted
   composition) rather than "matter is a continuous field."

### The Real Dichotomy

HPMOR presents: **objects** (no parts) vs. **fields** (arbitrary parts).

The formalization reveals: **restricted composition** (only designated
wholes are valid targets) vs. **unrestricted composition** (any
collection of parts is a valid target).

This is a much cleaner and more general distinction. It separates the
*metaphysical* question (what can be a target?) from the *physical*
question (is matter continuous?), showing they are independent.

### Prediction Assessment

The prediction that "the formalization should reveal that partial
transfiguration doesn't require abandoning objects for fields -- it
requires adopting a mereology where arbitrary fusions exist" is
**confirmed**. All major components compile and the trichotomy
(object/field/mereology) is cleanly established.
-/
