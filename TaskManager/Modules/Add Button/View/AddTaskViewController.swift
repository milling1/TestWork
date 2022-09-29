//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by user on 22.09.2022.
//

import UIKit

protocol AddTaskView: AnyObject {
    func titleAndDescription(title: String, description: String?)
}

class AddTaskViewController: UIViewController, AddTaskView {
    
    @IBOutlet weak private var addTaskLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var createTaskButton: UIButton!
    
    var delegate: HomeView?
    var presenter: AddViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarItem()
        titleTextField.addTarget(self, action: #selector(hiddenButton), for: .editingChanged)
        setTextField()
    }
    
    func titleAndDescription(title: String, description: String?) {
        titleTextField.text = title
        subtitleTextField.text = description
    }
    
    private func setTextField() {
        titleTextField.delegate = self
        titleTextField.layer.cornerRadius = 8
        titleTextField.clipsToBounds = true
        
        subtitleTextField.delegate = self
        subtitleTextField.layer.cornerRadius = 8
        subtitleTextField.clipsToBounds = true
    }
    
    private func setBarItem() {
        navigationController?.navigationBar.tintColor = .taskManagerColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func createTask(_ sender: Any) {
        presenter.createTaskMVP(title: titleTextField.text ?? "", description: subtitleTextField.text)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func hiddenButton() {
        createTaskButton.isHidden = titleTextField.text!.isEmpty
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        subtitleTextField.resignFirstResponder()
        return true
    }
}
