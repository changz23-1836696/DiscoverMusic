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

class CommentCell : UITableViewCell {
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var comment: UILabel!
    
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func play(_ sender: UIButton) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCell = self.tableView.dequeueReusableCell(withIdentifier: DetailViewController.CELL_STYLE) as! CommentCell
        cell.user?.text = firstNames[indexPath.row]
        cell.rating?.text = ratings[indexPath.row] + " stars"
        cell.comment?.text = comments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // zhe ge song shi ni yao de musicID
    public var song : String = ""
    //
    public var author : String = ""
    public var rating : UInt = 0
    public var comments : [String] = []
    public var users : [String] = []
    public var ratings : [String] = []
    public var firstNames: [String] = []
    public var db: Firestore!
    public var url : String = ""
    static let CELL_STYLE = "commentCellType"
    @IBOutlet weak var tableView: UITableView!
    
    
    func fetchData() {
        print(song)
        db.collection("CommentHistory").whereField("musicID", isEqualTo: String(song)).getDocuments{ [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print(querySnapshot!.documents)
                    var fname: String = "guest"
                    db.collection("users").whereField("uid", isEqualTo: document.data()["userID"] as! String)
                        .getDocuments() { (QuerySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for doc in QuerySnapshot!.documents {
                                    fname = doc.data()["fName"] as! String
                                }
                            }
                            self.firstNames.append(fname)
                            self.ratings.append(document.data()["rating"] as! String)
                            self.comments.append(document.data()["comment"] as! String)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goRating" {
            let vc = segue.destination as! RatingViewController
            vc.musicID = self.song
        }
    }
    
    private func getCollection() {
        db.collection("")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.dataSource = self
        tableView.delegate = self
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        fetchData()
    }


}
