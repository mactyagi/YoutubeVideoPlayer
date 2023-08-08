//
//  VideoTableViewCell.swift
//  YoutubeVideoPlayer
//
//  Created by Manu on 07/08/23.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
    }
}
