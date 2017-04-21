//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

@objc class UpdatedUserIndustries: NSObject {
    fileprivate enum JSONKeys {
        static let primaryIndustryKey = "1"
        static let secondaryIndustryKey = "2"
        static let tertiaryIndustryKey = "3"
    }
    let primaryIndustry: Industry
    let secondaryIndustry: Industry
    let tertiaryIndustry: Industry
    
    init(primaryIndustry: Industry, secondaryIndustry: Industry,
         tertiaryIndustry: Industry) {
        self.primaryIndustry = primaryIndustry
        self.secondaryIndustry = secondaryIndustry
        self.tertiaryIndustry = tertiaryIndustry
    }
}

extension UpdatedUserIndustries: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.primaryIndustryKey: primaryIndustry.id,
                JSONKeys.secondaryIndustryKey: secondaryIndustry.id,
                JSONKeys.tertiaryIndustryKey: tertiaryIndustry.id]
    }
}
