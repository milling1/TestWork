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
        circleLabel.layer.borderColor = UIColor.taskManagerColor.cgColor
        circleLabel.layer.borderWidth = 2.0
    }
    
    private func setupTaskLabel() {
        taskLabel.numberOfLines = 0
    }
    
    func strikethroughText() {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: taskLabel.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        taskLabel.attributedText = attributeString
    }
    
    func configureCell(viewModel: ModelTask) {
        var text = viewModel.title
        
        if let description = viewModel.description {
            text.append(contentsOf: "\n\(viewModel.description ?? "")")
        }
        taskLabel.text = text
    }
}
