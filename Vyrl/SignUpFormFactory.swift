//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol SignUpFormMaking {
    static func make(fields: [FormView]) -> SignUpFormInteractor
}

enum SignUpFormFactory: SignUpFormMaking {

    static func make(fields: [FormView]) -> SignUpFormInteractor {
        guard fields.count == SignUpFormIndex.count else {
            fatalError("Invalid form definition for SignUpFormInteractor")
        }
        let emailItem = FormItem(field: .email, formView: fields[ContactInfoFormIndex.email])
        //TODO: Map rest of fields
        let formFieldsInteractor = FormFieldsInteractor(fields: [emailItem])
        return SignUpFormInteractor(fieldsInteractor: formFieldsInteractor)
    }
}
