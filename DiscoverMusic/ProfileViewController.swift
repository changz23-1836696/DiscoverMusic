//
//  ProfileViewController.swift
//  DiscoverMusic
//
//  Created by Hailun Zhang on 6/1/21.
//

import UIKit

class ProfileViewController: UIViewController {

    var uid:String = ""
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        
        // if already logged in then skip the buttons and jump directly to user info
        if !UserInfo.sharedInstance.uid.isEmpty {
            let loggedInViewController = self.storyboard?.instantiateViewController(identifier: "loggedInVC") as? LoggedInViewController
//            self.view.window?.rootViewController = loggedInViewController
//            self.view.window?.makeKeyAndVisible()
            self.present(loggedInViewController!, animated: true, completion: nil)
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.






        
    }

    


}
