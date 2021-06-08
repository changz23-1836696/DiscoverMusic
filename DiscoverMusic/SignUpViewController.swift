//
//  SignUpViewController.swift
//  DiscoverMusic
//
//  Created by Danfeng Yang on 6/5/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var errorMsg: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorMsg.alpha = 0
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signUpAction(_ sender: Any) {
        
        // validation of entries
        let error = validateInfo()
        if error != nil {
            showError(error!)
        } else {
            
            // trim white spaces for all text entries
            let firstName = fName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let emailData = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordData = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: emailData, password: passwordData) { (result, err) in
                
                if err != nil {
                    
                    self.showError("Internal error when creating user")
                }
                else {
                    
                    // store the created user in firestore
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid ).setData([
                                                        "fName":firstName,
                                                        "lName":lastName,
                                                        "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Internal error when saving user")
                        }
                    }
                    

                    UserInfo.sharedInstance.uid = result!.user.uid
                    self.showProfile()

                }
                
            }
            
            
            
        }
        
        
    }
    
    // validates all text entries and returns error if doesn't meet requirements
    // requirements: all fields are non empty and password must have length > 6
    func validateInfo() -> String? {
        
        if fName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "First name missing"
        }
        if lName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Last name missing"
        }
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Email missing"
        }
        if password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Password missing"
        }

        let trimmedPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedPassword.count <= 6 {
            return "Password must have length > 6."
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        
        errorMsg.text = message
        errorMsg.alpha = 1
    }
    
//    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
//
//        self.performSegue(withIdentifier: "signUptoProfile", sender: self)
//
//    }
//    
    func showProfile() {



//        let profileViewController = storyboard?.instantiateViewController(identifier: "profileVC") as? ProfileViewController
//
//        view.window?.rootViewController = profileViewController
//        view.window?.makeKeyAndVisible()

        let loggedInViewController = storyboard?.instantiateViewController(identifier: "loggedInVC") as? LoggedInViewController

        view.window?.rootViewController = loggedInViewController
        view.window?.makeKeyAndVisible()


    }
    
}
