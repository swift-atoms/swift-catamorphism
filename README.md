# swift-catamorphism

Use this package to collapse a recursive enum into a single value by writing only what one layer contributes: attach `@Catamorphism` to the enum, alongside `@FunctorBase` and `@Recursive`, and call the generated `catamorphism` with an algebra over the enum's base functor (for example `Tree.Base<Int>`). When the algebra also needs the original subterm, use swift-paramorphism; when it needs the results of earlier layers, use swift-histomorphism; when it needs a second, helper fold, use swift-zygomorphism.

## Laws

- The fold runs from the leaves to the root: every child is folded before its parent's layer reaches the algebra, so the algebra only ever sees layers whose recursive positions already hold results.
- The algebra runs exactly once per layer and nothing is cached between calls: folding the same value twice runs the algebra again.
- A layer with no recursive positions is passed to the algebra directly; its result is the fold's result for that subterm.
- Recursion follows the call stack, one frame per layer, so a fold's depth is bounded by stack size; 1,000 layers is the deepest case tested.
- The expansion uses `project()` from `@Recursive` and `map` on the base functor from `@FunctorBase`; without both, the generated member does not compile.
- The generated member is `public` when the enum is declared `public`, and internal otherwise.
