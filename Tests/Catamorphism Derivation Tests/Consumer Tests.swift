import Catamorphism_Derivation
import Testing

@Catamorphism
private indirect enum Natural {
    case zero
    case successor(Natural)
}

@Test
func `catamorphism folds from leaves to root`() {
    let two = Natural.successor(.successor(.zero))
    let count = two.catamorphism { (layer: Natural.Base<Int>) -> Int in
        switch layer {
        case .zero: 0
        case let .successor(child): child + 1
        }
    }
    #expect(count == 2)
}
