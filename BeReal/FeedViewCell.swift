//
//  FeedViewCell.swift
//  BeReal
//
//  Created by Corey Taylor on 3/30/24.
//

import UIKit
import AlamofireImage
import Alamofire

class FeedViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    
    private var imageDataRequest: DataRequest?
    
    func configure(with post: Post) {
        // TODO: Pt 1 - Configure Post Cell
        // // A lot of the following returns optional values so we'll unwrap them all together in one big `if let`
        // Get the current user.
        if let currentUser = User.current,
           
            // Get the date the user last shared a post (cast to Date).
           let lastPostedDate = currentUser.lastPostedDate,
           
            // Get the date the given post was created.
           let postCreatedDate = post.createdAt,
           
            // Get the difference in hours between when the given post was created and the current user last posted.
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {
            
            // Hide the blur view if the given post was created within 24 hours of the current user's last post. (before or after)
            blurView.isHidden = abs(diffHours) < 24
        } else {
            
            // Default to blur if we can't get or compute the date's above for some reason.
            blurView.isHidden = false
            // Username
            if let user = post.user {
                userName.text = user.username
                
            }
            if let imageFile = post.imageFile,
               let imageUrl = imageFile.url {
                
                // Use AlamofireImage helper to fetch remote image from URL
                imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                    switch response.result {
                    case .success(let image):
                        // Set image view image with fetched image
                        self?.feedImage.image = image
                    case .failure(let error):
                        print("❌ Error fetching image: \(error.localizedDescription)")
                        break
                    }
                }
                
            } else{
                print ("hola")}
            captionLabel.text = post.caption
            let dateFormatter = DateFormatter()
            let FormattedDate = dateFormatter.string(for: post.createdAt)
            dateLabel.text = FormattedDate
            
            
        }
        
    }
        override  func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            
        }//Configure the view for the selected state
    }
    
    

