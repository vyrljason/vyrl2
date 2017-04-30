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

        let vyrlUsernameItem = FormItem(field: .vyrlUsername, formView: fields[SignUpFormIndex.vyrlUsername])
        let emailItem = FormItem(field: .email, formView: fields[SignUpFormIndex.email])
        let emailConfirmationItem = FormItem(field: .email, formView: fields[SignUpFormIndex.emailConfirmation])
        let passwordItem = FormItem(field: .password, formView: fields[SignUpFormIndex.password])
        let instagramUsernameItem = FormItem(field: .instagramUsername, formView: fields[SignUpFormIndex.instagramUsername])
        
        let formFieldsInteractor = FormFieldsInteractor(fields: [vyrlUsernameItem, emailItem, emailConfirmationItem, passwordItem, instagramUsernameItem])
        return SignUpFormInteractor(fieldsInteractor: formFieldsInteractor)
    }
}
