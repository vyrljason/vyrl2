//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol FormFieldsInteracting: class {
    var fields: [FormItem] { get }
    weak var delegate: FormActionDelegate? { get set }
    func next(textField: UITextField) -> UITextField?
}

final class FormFieldsInteractor: NSObject, FormFieldsInteracting, UITextFieldDelegate {
    let fields: [FormItem]
    weak var delegate: FormActionDelegate?

    init(fields: [FormItem]) {
        self.fields = fields
        super.init()
        setUp(delegate: self)
    }

    private func setUp(delegate: UITextFieldDelegate?) {
        fields.forEach { $0.textField.delegate = self }
    }

    func next(textField: UITextField) -> UITextField? {
        guard let relatedFormItem = fields.filter({ $0.textField == textField }).first else { return nil }
        return fields.after(item: relatedFormItem)?.textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = next(textField: textField) {
            nextTextField.becomeFirstResponder()
        } else {
            delegate?.didTapAction()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let relatedFormItem = fields.filter({ $0.textField == textField }).first else { return true }

        var updatedString: NSString? = textField.text as NSString?
        updatedString = updatedString?.replacingCharacters(in: range, with: string) as NSString?
        textField.text = updatedString as String?

        _ = relatedFormItem.status
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let relatedFormItem = fields.filter({ $0.textField == textField }).first else { return }
        relatedFormItem.clearError()
    }

}
