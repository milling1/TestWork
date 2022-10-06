//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by user on 14.09.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!

    static let identifier = String(describing: TaskTableViewCell.self)
    
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
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = .systemBackground
        descriptionLabel.backgroundColor = .systemBackground
        descriptionLabel.numberOfLines = 0
    }
    
    func changeCompletedTask() {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: titleLabel.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        titleLabel.attributedText = attributeString
        titleLabel.textColor = .completedColor
    }
    
    func configureCell(viewModel: ModelTask, backgroundColor: UIColor) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtitle
        circleLabel.backgroundColor = backgroundColor
    }
}
