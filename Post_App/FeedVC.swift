//
//  FeedVC.swift
//  Post_App
//
//  Created by Pixelplus Interactive on 19.08.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController {
    
    var imageArray = [String]()
    var userMailArray = [String]()
    var userCommentArray = [String]()
    var documentIdArray = [String]()
    var likeArray = [Int]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore() {
        let firestore = Firestore.firestore()
        firestore.collection("Posts").order(by: "date").addSnapshotListener { snapshot, error in
            if error != nil {
                //MARK: BURADAN DEVAM ET!
            }
            else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.userMailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.documentIdArray.append(documentId)
                        
                        if let userImage = document.get("imageUrl") as? String {
                            self.imageArray.append(userImage)
                        }
                        
                        if let userMail = document.get("postedBy") as? String {
                            self.userMailArray.append(userMail)
                        }
                        
                        if let userComment = document.get("postComment") as? String {
                            self.userCommentArray.append(userComment)
                        }
                        
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableViewCellIdentifier.feedCell, for: indexPath) as! FeedCell
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        cell.userMailLabel.text = userMailArray[indexPath.row]
        cell.feedImageView.sd_setImage(with: URL(string: imageArray[indexPath.row]), completed: nil)
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
