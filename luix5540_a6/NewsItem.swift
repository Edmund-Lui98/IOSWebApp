//
//  NewsItem.swift
//  luix5540_a6
//
//  Created by Prism Student on 2020-04-09.
//  Copyright © 2020 Edmund Lui. All rights reserved.
//

import UIKit

class NewsItem: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
