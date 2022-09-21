//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by user on 14.09.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    static let identifire = String(describing: TaskTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCircleLabel()
        setupTaskLabel()
    }
    
    private func setupCircleLabel() {
        circleLabel.layer.cornerRadius = circleLabel.frame.width / 2
        circleLabel.layer.masksToBounds = true
        let color = UIColor.init(netHex: 0xD44F4F)
        circleLabel.layer.borderColor = color.cgColor
        circleLabel.layer.borderWidth = 2.0
    }
    
    private func setupTaskLabel() {
        taskLabel.numberOfLines = 0
    }
    
    func strikethroughText(label: UILabel) {
        
        let attributeString:NSMutableAttributedString = NSMutableAttributedString(string: label.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        taskLabel.attributedText = attributeString
    }
    
    func configureCell(viewModel: ModelTask) {
        taskLabel.text = "\(viewModel.title)" + "\n\(viewModel.description ?? "")"
    }
}

