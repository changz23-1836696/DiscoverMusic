//
//  ViewController.swift
//  DiscoverMusic
//
//  Created by Chang Zeng on 5/30/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SearchResult: Codable{
    let resultCount: UInt
    let results: [Song]
}

struct Song: Codable{
    let artistName: String
    let collectionName: String
    let trackName: String
    let artworkUrl100: String
}

class SongResultCell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var author: UILabel!
}

class SearchViewController: UIViewController, UIScrollViewDelegate {
    public var db: Firestore!
    static let CELL_STYLE = "songCellType"
    public var songs : String = ""
    public var authors : String = ""
    public var rating: UInt = 0
    public var searchTime: UInt = 0
    public var users : [String] = []
    public var comments : [String] = []
    public var ratings : [String] = []
    


//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var result: UILabel!
    public var screenHeight = UIScreen.main.bounds.height
    public var scrollViewContentHeight = 1200 as CGFloat
    public var resultInfo : SearchResult? = nil
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return songs.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: SongResultCell = self.tableView.dequeueReusableCell(withIdentifier: SearchViewController.CELL_STYLE) as! SongResultCell
//        cell.name?.text = songs
//        cell.author?.text = authors
//        return cell
//    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == self.scrollView {
//            tableView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
//        }
//
//        if scrollView == self.tableView {
//            self.tableView.isScrollEnabled = (tableView.contentOffset.y > 0)
//        }
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50.0
//    }
    
    func alertMessage(mess: String) {
        let controller = UIAlertController(title: "Error", message: mess, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Good to go"), style: .default, handler: {
            _ in NSLog("k")
        }))
        present(controller, animated: true, completion: {NSLog("kk")})
    }
    
    func fetchData(_ fetchString: String) {
        db.collection("MusicCollections").document(fetchString).getDocument { (querySnapshot, err) in
            if let document = querySnapshot, document.exists {
                self.songs = (document.documentID)
                self.authors = (document.data()?["artist"] as! String)
                self.rating = (document.data()?["rating"] as! UInt)
                self.searchTime = (document.data()?["searchTime"] as! UInt)
            } else {
                self.alertMessage(mess: "Song not found")
                }
        }
    }
    
    func fetchComment(fetchString: String) {
        print(fetchString)
        db.collection("CommentHistory").whereField("musicID", isEqualTo: fetchString).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if (querySnapshot!.documents == []) {
                    print("No comments here")
                }
                for document in querySnapshot!.documents {
                    self.users.append(document.data()["userID"] as! String)
                    self.ratings.append(document.data()["rating"] as! String)
                    self.comments.append(document.data()["comment"] as! String)
                }
                DispatchQueue.main.async{
                    self.result.text = self.songs + "                  " + self.authors
                }
            }
    }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {

        self.performSegue(withIdentifier: "toDetail", sender: self)

    }
    
    @IBAction func search(_ sender: UIButton) {
        let song = String(searchBar.text ?? "")
        NSLog((String(describing: song)))
        fetchData(song)
        fetchComment(fetchString: song)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = tableView.indexPathForSelectedRow{
            let questionView = segue.destination as! DetailViewController
            questionView.song = songs
            questionView.author = authors
            questionView.rating = rating
//            questionView.comments = comments
//            questionView.ratings = ratings
//            questionView.users = users
//        }
    }
    
    private func getCollection() {
        db.collection("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        songs = ""
        authors = ""
        rating = 0
        searchTime = 0
//        scrollView.delegate = self
//        self.scrollView.bounces = false
//        self.tableView.bounces = true
//        tableView.isScrollEnabled = false
//        self.tableView.register(UINib(nibName: "SongResultCell", bundle: nil), forCellReuseIdentifier: "SongResultCell")
//        tableView.dataSource = self
//        tableView.delegate = self
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.tapFunction))
        result.isUserInteractionEnabled = true
        result.addGestureRecognizer(tap)
    }
    
    


}

