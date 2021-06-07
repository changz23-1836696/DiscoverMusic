//
//  HomeViewController.swift
//  DiscoverMusic
//
//  Created by Fishzz on 6/6/21.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Music: Codable{
    let name: String
    let artist: String
    let rating: Double
    let searchTime: Int
    
    init(snapshot: QueryDocumentSnapshot) {
        name = snapshot.documentID
        var snapshotValue = snapshot.data()
        artist = snapshotValue["artist"] as? String ?? "not found"
        rating = snapshotValue["rating"] as? Double ?? 0
        searchTime = snapshotValue["searchTime"] as? Int ?? 0
    }
}

class LeaderBoardCell : UITableViewCell {
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var searchTime: UILabel!
    
}

class LeaderBoardSource : NSObject, UITableViewDataSource {
    public var fullData: [Music] = []
    public var ratings: [Double] = []
    public var names: [String] = []
    public var searchTimes: [Int] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LeaderBoardCell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.CELL_STYLE, for: indexPath) as! LeaderBoardCell
        cell.songName?.text = names[indexPath.row]
        cell.rating?.text = String(ratings[indexPath.row])
        cell.searchTime?.text = String(searchTimes[indexPath.row])
        return cell
    }
}

class LeaderBoardSelector: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

class HomeViewController: UIViewController {
    static let CELL_STYLE = "musicCell"
    var data = LeaderBoardSource()
    let actor = LeaderBoardSelector()
    public var db: Firestore!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = data
        tableView.delegate = actor
        db = Firestore.firestore()
        if (self.data.names.count == 0) {
            fetch()
        }
    }
    
    
    func fetch() {
        db.collectionGroup("MusicCollections").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let musicItem = Music(snapshot: document)
                    self.data.fullData.append(musicItem)
                    self.data.names.append(musicItem.name)
                    self.data.ratings.append(musicItem.rating)
                    self.data.searchTimes.append(musicItem.searchTime)
                    print(self.data.names)
                }
                self.tableView.reloadData()
            }
        }
    }
}
