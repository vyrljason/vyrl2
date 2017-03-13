//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol FormInteracting: class {
    var fieldsInteractor: FormFieldsInteracting { get }
    var status: ValidationStatus { get }
}
