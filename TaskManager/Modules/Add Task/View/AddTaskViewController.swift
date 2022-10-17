//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by user on 22.09.2022.
//

import UIKit

protocol AddTaskView: AnyObject {
    func configWith(title: String, subtitle: String)
}

class AddTaskViewController: UIViewController {
    
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
    var delegate: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarItem()
        setTextField()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGR)
        presenter.present()
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
    
    @IBAction func saveTask(_ sender: Any) {
        presenter.saveTask(title: titleTextField.text ?? "", subtitle: subtitleTextField.text, isActive: true)
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITextFieldDelegate
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

//MARK: - AddTaskView
extension AddTaskViewController: AddTaskView {
    func configWith(title: String, subtitle: String) {
        titleTextField.text = title
        subtitleTextField.text = subtitle
    }
}
