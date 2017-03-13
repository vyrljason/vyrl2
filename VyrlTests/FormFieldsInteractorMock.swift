//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class FormFieldsInteractorMock: FormFieldsInteracting {
    let fields = [FormItem]()
    weak var delegate: FormActionDelegate?
    func next(textField: UITextField) -> UITextField? { return nil }
}
