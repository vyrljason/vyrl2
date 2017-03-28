//
//  SignUpViewController.swift
//  Vyrl
//
//  Created by Benjamin Hendricks on 3/28/17.
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        //        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func removeNonAlphanumericForIG() -> String {
        let charSet = NSMutableCharacterSet.alphanumeric()
        charSet.addCharacters(in: "._")
        charSet.invert()
        return self.trimmingCharacters(in: charSet as CharacterSet)
    }
    
    func removeNonAlphanumericForVYRL() -> String {
        let charSet = NSMutableCharacterSet.alphanumeric()
        charSet.addCharacters(in: "-_")
        charSet.invert()
        return self.trimmingCharacters(in: charSet as CharacterSet)
    }
    
    func removeWhitespacesAndNewlines() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

class SignupDataManager: NSObject {
    
    static let sharedInstance = SignupDataManager()
    private override init() {}
    
    // VYRL.
    var username: String?
    var email1: String?
    var email2: String?
    var password: String?
    
    // Social networks.
    var platform: String?
    var platformUsername: String?
}


class SignUpViewController: UIViewController {
    static let storyboardName: String = "SignUpViewController"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    let data = [AnyObject]()
    let userDeets = SignupDataManager.sharedInstance
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var tocAndPrivacyView: UIView!
    @IBOutlet weak var tocAndPrivacyLabel: UILabel!
  
    var brandSwitch : UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tableview.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        // Setup ui.
        signupButton.backgroundColor = UIColor.rouge
        
        tocAndPrivacyLabel.textColor = UIColor.greyishBrown
        tocAndPrivacyView.backgroundColor = UIColor.white
        
        // Load IG Tap Gesture.
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.openTOC))
//        tocAndPrivacyLabel.addGestureRecognizer(tapGesture)
        tocAndPrivacyLabel.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            self.tableView.contentInset = contentInsets
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsets.zero
    }
    
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        signup()
    }
    
    func signup() {
        let userDeets = SignupDataManager.sharedInstance
        
        userDeets.platform = "instagram"
        
        if let username = userDeets.username,
            let email = userDeets.email1,
            let email2 = userDeets.email2,
            let _ = userDeets.platform,
            let _ = userDeets.platformUsername {
            
            // If emails don't match.
            if (email != email2) {
                // Display a UIAlertView.
                let controller = UIAlertController(title: "", message: "Emails do not match. Please correct and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
                
                return
            }
            else if !email.isValidEmail() {
                // Display a UIAlertView.
                let controller = UIAlertController(title: "", message: "Your email doesn't seem to be a valid email. If it is, they match and you are still getting this message, please contact support@govyrl.io", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
                
                return
            }
            
            // Present alert if password is nil.
            if let password = userDeets.password {
                // If we have a valie email address.
                if username.length > 2 && password.length > 5 {
//                    SVProgressHUD.showWithStatus("Creating account")
                    
//                    APIManager.sharedInstance.registerNewUserWithUsername(username: username, email: email, password: password, platform: platform, platformUsername: platformUsername.stringByReplacingOccurrencesOfString("@", withString: ""), completion: { (data) in
//                        
////                        SVProgressHUD.dismiss()
//                        
//                        // Error. Present alert.
//                        if let error = data["error"] as? [String: AnyObject] {
//                            
//                            if let message = error["message"] as? String where
//                                message.contains("Account already claimed") {
//                                let alertController = UIAlertController(title: "Error", message: "That account has already been claimed.", preferredStyle: .Alert)
//                                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//                                self.presentViewController(alertController, animated: true, completion: nil)
//                                return
//                            } else if let message = error["message"] as? String where
//                                message.contains("`email` already exists") {
//                                let alertController = UIAlertController(title: "Error", message: "That email has already been taken.", preferredStyle: .Alert)
//                                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//                                self.presentViewController(alertController, animated: true, completion: nil)
//                                return
//                            } else if let message = error["message"] as? String where message.contains("minLength") {
//                                let alertController = UIAlertController(title: "Error", message: "Usernames must be at least 4 characters", preferredStyle: .Alert)
//                                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//                                self.presentViewController(alertController, animated: true, completion: nil)
//                                return
//                            }
//                            
//                            let alertController = UIAlertController(title: "Error", message: "Something went wrong, please try again.", preferredStyle: .Alert)
//                            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//                            self.presentViewController(alertController, animated: true, completion: nil)
//                            return
//                        }
//                        
//                        // Fabric.
//                        Answers.logSignUpWithMethod("User registered", success: true, customAttributes: nil)
//                        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//                        
//                        if let brandSwitch = self.brandSwitch where brandSwitch.on {
//                            APIManager.sharedInstance.setIsBrand()
//                            
//                            if let dmVC = storyboard.instantiateViewControllerWithIdentifier("DMWalkthroughViewController") as? DMWalkthroughViewController {
//                                self.navigationController?.pushViewController(dmVC, animated: true)
//                                return
//                            }
//                        }
//                        
//                        
//                        if let bioCodeVC = storyboard.instantiateViewControllerWithIdentifier("BioCodeWalkthroughViewController") as? BioCodeWalkthroughViewController {
//                            self.navigationController?.pushViewController(bioCodeVC, animated: true)
//                        }
//                        
//                        //                        self.performSegueWithIdentifier("BioCodeWalkthroughViewController", sender: self)
//                    })
                }
                else {
                    // Display a UIAlertView.
                    let controller = UIAlertController(title: "", message: "Username needs to contain more than 2 characters and password needs more than 5.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    controller.addAction(okAction)
                    present(controller, animated: true, completion: nil)
                }
            }
            else {
                // Display a UIAlertView.
                let controller = UIAlertController(title: "", message: "Passwords must contain at least 6 characters, contain 1 or more alpha, numeric and capital characters (Eg. somethingAwesome1)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
            }
            
        }
        else {
            // Display a UIAlertView.
            let controller = UIAlertController(title: "", message: "Looks like all required fields aren't filled out. Please try again 😝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: - Table view data source

extension SignUpViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 6
        }
        else if section == 1 {
            return 4
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 { // Header cell.
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
                cell.backgroundColor = UIColor.lightGray
                cell.textLabel?.text = "VYRL Account Details"
                return cell
            }
            else if indexPath.row == 1 { // SignupUsernameTableViewCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "SignupUsernameTableViewCell", for: indexPath) as! SignupUsernameTableViewCell
                cell.backgroundColor = UIColor.white
                cell.usernameTextField.backgroundColor = UIColor.clear
                
                // add bottom underline
                let border = CALayer()
                let width = CGFloat(1.0)
                border.borderColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 0, y: cell.frame.size.height - width,   width:  cell.frame.size.width, height: cell.frame.size.height)
                
                border.borderWidth = width
                cell.layer.addSublayer(border)
                cell.layer.masksToBounds = true
                
                return cell
            }
            else if indexPath.row == 2 { // SignupEmailTableViewCell 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "SignupEmail1TableViewCell", for: indexPath) as! SignupEmail1TableViewCell
                cell.backgroundColor = UIColor.white
                cell.emailTextField.backgroundColor = UIColor.clear
                
                // add bottom underline
                let border = CALayer()
                let width = CGFloat(1.0)
                border.borderColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 0, y: cell.frame.size.height - width,   width:  cell.frame.size.width, height: cell.frame.size.height)
                
                border.borderWidth = width
                cell.layer.addSublayer(border)
                cell.layer.masksToBounds = true
                
                return cell
            }
            else if indexPath.row == 3 { // SignupEmailTableViewCell 2
                let cell = tableView.dequeueReusableCell(withIdentifier: "SignupEmail2TableViewCell", for: indexPath) as! SignupEmail2TableViewCell
                cell.backgroundColor = UIColor.white
                cell.emailTextField.backgroundColor = UIColor.clear
                
                // add bottom underline
                let border = CALayer()
                let width = CGFloat(1.0)
                border.borderColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 0, y: cell.frame.size.height - width,   width:  cell.frame.size.width, height: cell.frame.size.height)
                
                border.borderWidth = width
                cell.layer.addSublayer(border)
                cell.layer.masksToBounds = true
                
                return cell
            }
            else if indexPath.row == 4 { // SignupPasswordTableViewCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "SignupPasswordTableViewCell", for: indexPath) as! SignupPasswordTableViewCell
                cell.backgroundColor = UIColor.white
                cell.passwordTextField.backgroundColor = UIColor.clear
                
                // add bottom underline
                let border = CALayer()
                let width = CGFloat(1.0)
                border.borderColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 0, y: cell.frame.size.height - width,   width:  cell.frame.size.width, height: cell.frame.size.height)
                
                border.borderWidth = width
                cell.layer.addSublayer(border)
                cell.layer.masksToBounds = true
                
                return cell
            }
            else if indexPath.row == 5 { // Footer cell.
                let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath)
                cell.textLabel?.textColor = UIColor.greyishBrown
                cell.backgroundColor = UIColor.lightGray
                cell.textLabel?.text = "Password must contain at least 6 characters, 1 uppercase letter and 1 number. Ex: Password1"
                return cell
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 { // Header cell.
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
                cell.backgroundColor = UIColor.lightGray
                cell.textLabel?.text = "Social network details"
                return cell
            }
            else if indexPath.row == 1 { // SignupInstagramTableViewCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "SignupInstagramTableViewCell", for: indexPath) as! SignupInstagramTableViewCell
                cell.backgroundColor = UIColor.white
                cell.instagramUsernameTextField.backgroundColor = UIColor.clear
                
                // add bottom underline
                let border = CALayer()
                let width = CGFloat(1.0)
                border.borderColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 0, y: cell.frame.size.height - width,   width:  cell.frame.size.width, height: cell.frame.size.height)
                
                border.borderWidth = width
                cell.layer.addSublayer(border)
                cell.layer.masksToBounds = true
                
                return cell
            }
            else if indexPath.row == 2 { // brand switch cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "BrandSwitchSignupCell", for: indexPath) as! BrandSwitchSignupCell
                cell.backgroundColor = UIColor.white
                brandSwitch = cell.brandSwitch
                return cell
            }
            else if indexPath.row == 3 { // Footer cell.
                let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath)
                cell.textLabel?.textColor = UIColor.greyishBrown
                cell.backgroundColor = UIColor.lightGray
                cell.textLabel?.text = "This is how we verify your account’s eligibility."
                return cell
            }
        }
        
        
        // This should never be hit.
        return UITableViewCell()
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 44
            }
            else {
                return UITableViewAutomaticDimension
            }
        }
        
        return UITableViewAutomaticDimension
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 5 {
            signup()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
