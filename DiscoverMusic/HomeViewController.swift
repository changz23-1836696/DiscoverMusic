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
import youtube_ios_player_helper

struct Music: Codable{
    let name: String
    let artist: String
    let rating: Double
    let searchTime: Int
    let score: Double
    init(snapshot: QueryDocumentSnapshot) {
        name = snapshot.documentID
        var snapshotValue = snapshot.data()
        artist = snapshotValue["artist"] as? String ?? "not found"
        rating = snapshotValue["rating"] as? Double ?? 0
        searchTime = snapshotValue["searchTime"] as? Int ?? 0
        score = 0.6 * rating + 0.4 * Double(searchTime)
    }
}

class LeaderBoardCell : UITableViewCell {
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var searchTime: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var indexNum: UILabel!
}

class LeaderBoardSource : NSObject, UITableViewDataSource {
    public var fullData: [Music] = []
    public var ratings: [Double] = []
    public var names: [String] = []
    public var searchTimes: [Int] = []
    public var indexes: [Int] = []
    public var artists: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LeaderBoardCell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.CELL_STYLE, for: indexPath) as! LeaderBoardCell
        cell.songName?.text = names[indexPath.row]
        cell.rating?.text = String(ratings[indexPath.row])
        cell.searchTime?.text = String(searchTimes[indexPath.row])
        cell.indexNum?.text = String(indexes[indexPath.row])
        cell.artist?.text = String(artists[indexPath.row])
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
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.load(withPlaylistId: "PLO0OHpxWYRp3BclPAa13OsgUt34X4ITlB", playerVars: ["playsinline": 1])
        tableView.dataSource = data
        tableView.delegate = actor
        db = Firestore.firestore()
        if (self.data.names.count == 0) {
            fetch()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchView = segue.destination as! SearchViewController
        searchView.musicNames = self.data.names
        searchView.artists = self.data.artists
        searchView.ratings2 = self.data.ratings
        searchView.searchTimes = self.data.searchTimes
        searchView.indexes = self.data.indexes
    }
    
    func fetch() {
        db.collectionGroup("MusicCollections").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var index = 1;
                for document in QuerySnapshot!.documents {
                    let musicItem = Music(snapshot: document)
                    self.data.fullData.append(musicItem)
                    self.data.indexes.append(index)
                    index += 1
                }
                self.data.fullData = self.data.fullData.sorted(by: { $0.score > $1.score })
                for music in self.data.fullData {
                    self.data.names.append(music.name)
                    self.data.ratings.append(music.rating)
                    self.data.searchTimes.append(music.searchTime)
                    self.data.artists.append(music.artist)
                }
                self.tableView.reloadData()
            }
        }
    }
}
