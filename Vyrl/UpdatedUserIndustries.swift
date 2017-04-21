//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

@objc class UpdatedUserIndustries: NSObject {
    fileprivate enum JSONKeys {
        static let industryName = "name"
    }
    let primaryIndustryName: String
    let secondaryIndustryName: String
    let tertiaryIndustryName: String
    
    init(primaryIndustryName: String, secondaryIndustryName: String,
         tertiaryIndustryName: String) {
        self.primaryIndustryName = primaryIndustryName
        self.secondaryIndustryName = secondaryIndustryName
        self.tertiaryIndustryName = tertiaryIndustryName
    }
}

extension UpdatedUserIndustries: DictionaryConvertible {
    var dictionaryRepresentation: [String: Any] {
        return [JSONKeys.industryName: primaryIndustryName]
//                "name1": secondaryIndustryName,
//                "name ": tertiaryIndustryName]
    }
}
