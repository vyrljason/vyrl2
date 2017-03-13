//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ContactInfoFormMaking {
    static func make(fields: [FormView], actionDelegate: FormActionDelegate) -> ContactInfoFormInteractor
}

enum ContactInfoFormFactory: ContactInfoFormMaking {

    static func make(fields: [FormView], actionDelegate: FormActionDelegate) -> ContactInfoFormInteractor {
        guard fields.count == ContactInfoFormIndex.count else {
            fatalError("Invalid form definition for ContactInfoFormInteractor")
        }
        let emailItem = FormItem(field: .email, formView: fields[ContactInfoFormIndex.email])
        let phoneItem = FormItem(field: .nonEmpty, formView: fields[ContactInfoFormIndex.phone])
        let formFieldsInteractor = FormFieldsInteractor(fields: [emailItem,
                                                                 phoneItem])
        formFieldsInteractor.delegate = actionDelegate
        return ContactInfoFormInteractor(fieldsInteractor: formFieldsInteractor)
    }
}
