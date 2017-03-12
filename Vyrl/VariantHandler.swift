//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol VariantHandling {
    var selectedVariants: [ProductVariant] { get }
    func pickedVariant(variantName: String, variantValue: String)
    var variantsCount: Int { get }
    func selectedVariantValue(for name: String) -> String?
    var allVariantsAreSelected: Bool { get }
    func renderable(forIndex index: Int) -> DetailTableCellRenderable
    func possibleVariants(forIndex index: Int) -> ProductVariants?
}

final class VariantHandler: VariantHandling {
    private var selected: [String: String] = [:]
    private let allVariants: [ProductVariants]
    
    init(allVariants: [ProductVariants]) {
        self.allVariants = allVariants
    }
    
    var allVariantsAreSelected: Bool {
        return selected.count == allVariants.count
    }
    
    var selectedVariants: [ProductVariant] {
        return selected.map { ProductVariant(name: $0, value: $1) }
    }
    
    var variantsCount: Int {
        return allVariants.count
    }
    
    func pickedVariant(variantName: String, variantValue: String) {
        selected[variantName] = variantValue
    }
    
    func selectedVariantValue(for name: String) -> String? {
        return selected[name]
    }
    
    func renderable(forIndex index: Int) -> DetailTableCellRenderable {
        let name: String = allVariants[index].name
        let value: String = selected[name] ?? ""
        return DetailTableCellRenderable(text: name, detail: value, mandatory: true)
    }
    
    func possibleVariants(forIndex index: Int) -> ProductVariants? {
        guard index < allVariants.count else { return nil }
        return allVariants[index]
    }
}
