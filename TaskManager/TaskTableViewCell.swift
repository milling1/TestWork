//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by user on 14.09.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

   
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var firstTextView: UITextField!
    @IBOutlet weak var secondTextView: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleImageView.clipsToBounds = true
        circleImageView.layer.cornerRadius = circleImageView.frame.size.width / 2
    }
    
   
}
