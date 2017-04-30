//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

extension String {
    var isValidPassword: Bool {
        let regex = "^(?=.*[A-Z])(?=.*[0-9])[\\S]{6,144}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    var strippedForInstagramUsernameValidation: String {
        let charSet = NSMutableCharacterSet.alphanumeric()
        charSet.addCharacters(in: "._")
        charSet.invert()
        let trimmedString = self.trimmingCharacters(in: charSet as CharacterSet)
        return trimmedString.strippedWhitespacesAndNewlines
    }
    
    var strippedForVYRLUsernameValidation: String {
        let charSet = NSMutableCharacterSet.alphanumeric()
        charSet.addCharacters(in: "-_")
        charSet.invert()
        let trimmedString = self.trimmingCharacters(in: charSet as CharacterSet)
        return trimmedString.strippedWhitespacesAndNewlines
    }
    
    var strippedWhitespacesAndNewlines: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
