//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol VariantHandling {
    var selectedVariants: [ProductVariant] { get }
    var allVariants: [ProductVariants] { get }
    func pickedVariant(variantName: String, variantValue: String)
    func variantsCount() -> Int
    func selectedVariant(for name: String) -> String?
}

final class VariantHandler: VariantHandling {
    var selectedVariants: [ProductVariant]
    let allVariants: [ProductVariants]
    
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
    
    func pickedVariant(variantName: String, variantValue: String) {
        let selected = ProductVariant(name: variantName, value: variantValue)
        selectVariant(inVariant: selected)
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
    
    func selectedVariant(for name: String) -> String? {
        return selectedVariants.filter { $0.name == name}.map { $0.value }.first
    }
}
