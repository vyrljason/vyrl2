//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ContactInfoFormMaking {
    static func make(fields: [FormView]) -> ContactInfoFormInteractor
}

enum ContactInfoFormFactory: ContactInfoFormMaking {

    static func make(fields: [FormView]) -> ContactInfoFormInteractor {
        guard fields.count == ContactInfoFormIndex.count else {
            fatalError("Invalid form definition for ContactInfoFormInteractor")
        }
        let emailItem = FormItem(field: .nonEmpty, formView: fields[ContactInfoFormIndex.email])
        let phoneItem = FormItem(field: .nonEmpty, formView: fields[ContactInfoFormIndex.phone])

        return ContactInfoFormInteractor(fields: [emailItem, phoneItem])
    }
}
