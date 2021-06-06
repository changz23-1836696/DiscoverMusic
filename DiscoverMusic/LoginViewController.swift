//
//  LoginViewController.swift
//  DiscoverMusic
//
//  Created by Danfeng Yang on 6/5/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    
    var uid:String = ""
    
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

    @IBAction func loginAction(_ sender: Any) {
        
        
        // trim text entries
        let emailData = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordData = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: emailData, password: passwordData) { (result, error) in
            
            if error != nil {
                // login error
                self.errorMsg.text = error!.localizedDescription
                self.errorMsg.alpha = 1
            } else {
           
//                let profileViewController = self.storyboard?.instantiateViewController(identifier: "profileVC") as? ProfileViewController
//                UserInfo.sharedInstance.uid = "000000"
//                self.view.window?.rootViewController = profileViewController
//                self.view.window?.makeKeyAndVisible()
                let loggedInViewController = self.storyboard?.instantiateViewController(identifier: "loggedInVC") as? LoggedInViewController
                UserInfo.sharedInstance.uid = "000000"
                self.view.window?.rootViewController = loggedInViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
}
