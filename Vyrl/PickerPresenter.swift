//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

typealias PickerCompletion = (_ result: String) -> Void

fileprivate struct Constants {
    static let toolbarHeight: CGFloat = 32
    static let anyWidth: CGFloat = 100
}

protocol PickerPresenting {
    func showPicker(within textField: UITextField, with data: [String], defaultValue: String?, onSelection: @escaping PickerCompletion)
}

final class PickerPresenter: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    fileprivate let picker: UIPickerView
    fileprivate weak var responder: UITextField?
    fileprivate var data: [String]?
    fileprivate var onSelection: PickerCompletion?
    fileprivate var selected: String?
    
    override init() {
        picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        super.init()
    }
    
    fileprivate func setUpPicker(on textField: UITextField) {
        responder = textField
        picker.dataSource = self
        picker.delegate = self
        textField.inputView = picker
        setUpAccessory(on: textField)
    }
    
    fileprivate func setUpAccessory(on textField: UITextField) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.anyWidth, height: Constants.toolbarHeight))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        toolbar.items = [space, done]
        textField.inputAccessoryView = toolbar
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data?.count ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = data?[row]
        runOnSelection()
    }
    
    func dismissPicker() {
        responder?.resignFirstResponder()
    }
    
    fileprivate func runOnSelection() {
        onSelection?(selected ?? "")
    }
}

extension PickerPresenter: PickerPresenting {
    func showPicker(within textField: UITextField, with data: [String], defaultValue: String?, onSelection: @escaping PickerCompletion) {
        setUpPicker(on: textField)
        self.data = data
        self.onSelection = onSelection
        mark(value: defaultValue ?? data.first)
        textField.becomeFirstResponder()
        runOnSelection()
    }
    
    fileprivate func mark(value: String?) {
        selected = value
        guard let unwrappedValue = value else {
            return
        }
        let index = data?.index(of: unwrappedValue) ?? 0
        picker.selectRow(index, inComponent: 0, animated: false)
    }
}
