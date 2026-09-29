import Functor_Base_Macro
import Recursive_Macro
import Catamorphism_Macro
import Testing

@FunctorBase
@Recursive
@Catamorphism
private indirect enum Tree {
    case leaf(Int)
    case node(Tree, Tree)
}

@FunctorBase
@Recursive
@Catamorphism
private indirect enum Count {
    case zero
    case successor(Count)
}

@Suite
struct `Catamorphism boundaries` {
    @Test
    func `the base case folds without recursion`() {
        #expect(Count.zero.catamorphism { (layer: Count.Base<Int>) -> Int in
            switch layer {
            case .zero: 0
            case let .successor(child): child + 1
            }
        } == 0)
    }

    @Test
    func `both children of a node are folded`() {
        let tree = Tree.node(.node(.leaf(1), .leaf(2)), .leaf(3))
        let sum = tree.catamorphism { (layer: Tree.Base<Int>) -> Int in
            switch layer {
            case let .leaf(value): value
            case let .node(left, right): left + right
            }
        }
        #expect(sum == 6)
    }

    @Test
    func `a thousand layers fold to a thousand`() {
        let deep = (0..<1_000).reduce(Count.zero) { value, _ in .successor(value) }
        #expect(deep.catamorphism { (layer: Count.Base<Int>) -> Int in
            switch layer {
            case .zero: 0
            case let .successor(child): child + 1
            }
        } == 1_000)
    }
}
