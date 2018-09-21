//
//  GraphFolderViewCell.swift
//  NetXMS Mobile Console
//
//  Created by Ēriks Jenkēvics on 05/09/2018.
//  Copyright © 2018 Raden Solutions. All rights reserved.
//

import UIKit

class PredefinedGraphFolderViewCell: UITableViewCell {
   @IBOutlet weak var folderIcon: UIImageView!
   @IBOutlet weak var folderName: UILabel!
   @IBOutlet weak var folderButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}