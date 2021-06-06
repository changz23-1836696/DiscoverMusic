//
//  LoggedInViewController.swift
//  DiscoverMusic
//
//  Created by Danfeng Yang on 6/5/21.
//

import UIKit

class LoggedInViewController: UIViewController {
    var uid:String = ""
    @IBOutlet weak var welcomeMsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            self.uid = UserInfo.sharedInstance.uid
            if !self.uid.isEmpty {
                welcomeMsg.alpha = 1
                welcomeMsg.text = "welcome, " + self.uid
//                registerBtn.isHidden = true
//                loginBtn.isHidden = true
            } else {
                welcomeMsg.alpha = 0
            }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
