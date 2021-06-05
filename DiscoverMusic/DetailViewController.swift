//
//  DetailViewController.swift
//  DiscoverMusic
//
//  Created by Hailun Zhang on 6/4/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class DetailViewController: UIViewController {
    
    public var song : String = ""
    public var author : String = ""
    public var rating : UInt = 0
    public var db: Firestore!

    
    func fetchData(_ fetchString: String) {
        db.collection("CommentHistory")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }


}
