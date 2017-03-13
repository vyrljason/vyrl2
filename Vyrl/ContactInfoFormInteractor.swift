//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ContactInfoFormInteracting: class, FormInteracting {
    var result: ContactInfo? { get }
}

private enum Constants {
    static let invalidData = NSLocalizedString("contactInfo.error.invalid", comment: "")
}

enum ContactInfoFormIndex: Int, CustomIntegerConvertible {
    case email
    case phone

    var integerValue: Int {
        return rawValue
    }

    static var count: Int {
        let lastElement = ContactInfoFormIndex.phone
        return lastElement.integerValue + 1
    }
}

final class ContactInfoFormInteractor: ContactInfoFormInteracting {

    let fieldsInteractor: FormFieldsInteracting

    init(fieldsInteractor: FormFieldsInteracting) {
        self.fieldsInteractor = fieldsInteractor
    }

    var result: ContactInfo? {
        let text: [String] = fieldsInteractor.fields.flatMap { $0.textField.text }.filter { $0.characters.count > 0 }
        guard text.count == ContactInfoFormIndex.count else { return nil }
        return ContactInfo(id: nil,
                           email: text[ContactInfoFormIndex.email.integerValue],
                           phone: text[ContactInfoFormIndex.phone.integerValue])
    }

    var status: ValidationStatus {
        let errorMessages: [String] = fieldsInteractor.fields.flatMap {
            if case .invalid(let message) = $0.status {
                return message
            } else {
                return nil
            }
        }
        guard errorMessages.count > 0 else { return .valid }
        return .invalid(errorMessage: Constants.invalidData)
    }
    
}
