//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by user on 22.09.2022.
//

import UIKit

protocol AddTaskView: AnyObject {
}

class AddTaskViewController: UIViewController, AddTaskView {
    
    struct Constants {
        static let textFieldCornerRadius: CGFloat = 8.00
        static let clipsToBounds = true
    }
    
    @IBOutlet weak private var addTaskLabel: UILabel!
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var subtitleTextField: UITextField!
    @IBOutlet weak private var createTaskButton: UIButton!
    @IBOutlet weak private var scrollView: UIScrollView!
    
    var presenter: AddViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarItem()
        setTextField()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGR)
    }
    
    private func setTextField() {
        titleTextField.delegate = self
        titleTextField.layer.cornerRadius = Constants.textFieldCornerRadius
        titleTextField.clipsToBounds = Constants.clipsToBounds
        
        subtitleTextField.delegate = self
        subtitleTextField.layer.cornerRadius = Constants.textFieldCornerRadius
        subtitleTextField.clipsToBounds = Constants.clipsToBounds
    }
    
    private func setBarItem() {
        navigationController?.navigationBar.tintColor = .taskManagerColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func willShowKeyboard(_ notification: Notification) {
        guard let info = notification.userInfo as NSDictionary?,
              let keyboardSize = info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else { return }
        
        let keyboardHeight = keyboardSize.cgRectValue.size.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func createTask(_ sender: Any) {
        presenter.createTask(title: titleTextField.text ?? "", description: subtitleTextField.text)
        navigationController?.popViewController(animated: true)
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        subtitleTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        createTaskButton.isHidden = !titleTextField.hasText
    }
}
