//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol VariantHandlerDelegate: class {
    func reloadVariants()
}

protocol VariantHandling {
    var selectedVariants: [ProductVariant] { get }
    var delegate: VariantHandlerDelegate? { get set }
    func pickFromVariants(variants: ProductVariants)
    func variantsCount() -> Int
    var allVariants: [ProductVariants] { get }
}

final class VariantHandler: VariantHandling {
    var selectedVariants: [ProductVariant]
    let allVariants: [ProductVariants]
    weak var delegate: VariantHandlerDelegate?
    
    init(allVariants: [ProductVariants]) {
        self.allVariants = allVariants
        selectedVariants = VariantHandler.preselectVariants(allVariants: allVariants)
    }
    
    private static func preselectVariants(allVariants: [ProductVariants]) -> [ProductVariant] {
        return allVariants.map {
            ProductVariant(name: $0.name, value: $0.values.first ?? "")
        }
    }
    
    func variantsCount() -> Int {
        return selectedVariants.count
    }
    
    func pickFromVariants(variants: ProductVariants) {
        // here the picker should be displayed, but we have ugly randomizer instead
        let randomIndex = Int(arc4random_uniform(UInt32(variants.values.count)))
        let selectedValue = variants.values[randomIndex]
        let selected = ProductVariant(name: variants.name, value: selectedValue)
        selectVariant(inVariant: selected)
        delegate?.reloadVariants()
    }
    
    private func selectVariant(inVariant: ProductVariant) {
        var index: Int = 0
        for variant in selectedVariants {
            if variant.name == inVariant.name {
                break
            }
            index += 1
        }
        selectedVariants[index] = inVariant
    }
}
