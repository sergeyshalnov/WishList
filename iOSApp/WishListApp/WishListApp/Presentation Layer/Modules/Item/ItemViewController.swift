//
//  ItemViewController.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit


class ItemViewController: UIViewController {
    
    // MARK: - Enum for edit mode
    
    enum ViewMode {
        case edit
        case add
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var urlTextField: UITextField!
    
    // MARK: - Custom TextView placeholder
    
    private let textViewPlaceholder : UILabel = {
        let label = UILabel()
        label.text = "Enter information about item"
        
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 0, y: 0)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    // MARK: - Private variables
    
    private let wishlistManager: IWishlistManager
    private var item: ItemModel
    private var mode: ViewMode
    
    // MARK: - Calculated variables
    
    // ModifiedItem is used to send changes to the server
    private var modifiedItem: ItemModel? {
        get {
            guard let newName = titleTextField.text == self.item.name ? "" : titleTextField.text else { return nil }
            guard let newInfo = infoTextView.text == self.item.comment ? "" : infoTextView.text else { return nil}
            guard let newUrl = urlTextField.text == self.item.url ? "" : urlTextField.text else { return nil }
            guard let costString = costTextField.text else { return nil }
            
            let costInt = Int(costString)
            
            if costInt == nil {
                let alert = Alert.controller(type: .costError)
                self.present(alert, animated: true, completion: nil)
            }
            
            guard let newCost = costInt == self.item.cost ? self.item.cost : costInt else { return nil }
            
            let item = ItemModel(id: self.item.id, name: newName, comment: newInfo, cost: newCost, url: newUrl)
            
            return item
        }
    }
    
    
    // MARK: - Initialization
    
    init(item: ItemModel, wishlistManager: IWishlistManager, mode: ViewMode) {
        self.item = item
        self.mode = mode
        self.wishlistManager = wishlistManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupLabels()
        setupNavigationController()
        setupKeyboardAppearance()
    }
    
    private func setupNavigationController() {
        editMode(mode == .add)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupLabels() {
        setupInputContent(isEditing: mode == .add)
        
        titleTextField.delegate = self
        infoTextView.delegate = self
        costTextField.delegate = self
        urlTextField.delegate = self
        
        titleTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        costTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        urlTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        infoTextView.textContainerInset = UIEdgeInsets.zero
        infoTextView.textContainer.lineFragmentPadding = 0
        infoTextView.addSubview(textViewPlaceholder)
        
        textViewPlaceholder.isHidden = mode == .edit
        
        if mode == .add { changeButtonState() }
    }
    
    private func setupKeyboardAppearance() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Use this function for pretty printed data
    private func setupInputContent(isEditing: Bool) {
        switch isEditing {
        case true:
            titleTextField.text = item.name
            infoTextView.text = item.comment
            costTextField.text = mode == .add ? "" : String(item.cost)
            urlTextField.text = item.url
        case false:
            titleTextField.text = item.name.isEmpty ? "-" : item.name
            infoTextView.text = item.comment.isEmpty ? "-" : item.comment
            costTextField.text = item.cost == 0 ? "-" : String(item.cost) + "$"
            urlTextField.text = item.url.isEmpty ? "-" : item.url
        }
    }
    
    
    // MARK: - Keyboard functions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let filteredConstraints = view.constraints.filter({ $0.identifier == "bottom" })
            
            if let bottomConstraint = filteredConstraints.first {
                bottomConstraint.constant = keyboardSize.height + 10
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let filteredConstraints = view.constraints.filter({ $0.identifier == "bottom" })
        
        if let bottomConstraint = filteredConstraints.first {
            bottomConstraint.constant = 20
        }
    }
    
    
    // MARK: - Button functions
    
    @objc private func editItemTouch() {
        editMode(true)
    }
    
    @objc private func endEditItemTouch() {
        guard let item = modifiedItem else { return }
        
        switch mode {
        case .add:
            wishlistManager.addItem(item: item) { (success, message, item) in
                DispatchQueue.main.async {
                    if success {
                        guard let postItem = item else {
                            let alert = Alert.controller(type: .responseItemError)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        
                        self.item = postItem
                        self.mode = .edit
                        self.editMode(false)
                    } else {
                        let alert = Alert.controller(type: .saveError, message: message)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                print("Add item: \(success)")
            }
        case .edit:
            wishlistManager.editItem(item: item) { (success, message, item) in
                DispatchQueue.main.async {
                    if success {
                        self.item.name = self.titleTextField.text ?? ""
                        self.item.cost = Int(self.costTextField.text ?? "") ?? 0
                        self.item.url = self.urlTextField.text ?? ""
                        self.item.comment = self.infoTextView.text
                        
                        self.editMode(false)
                    } else {
                        let alert = Alert.controller(type: .saveError, message: message)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                print("Edit save: \(success)")
            }
        }
    }
    
    
    // MARK: - TextField functions
    
    @objc private func textFieldChanged() {
        changeButtonState()
    }
    
    
    // MARK: - Private functions
    
    private func changeButtonState() {
        guard let titleFlag = titleTextField.text?.isEmpty else { return }
        guard let costFlag = costTextField.text?.isEmpty else { return }
        guard let urlFlag = urlTextField.text?.isEmpty else { return }
        let inputIsEmpty = infoTextView.text.isEmpty || titleFlag || costFlag || urlFlag
        
        navigationItem.rightBarButtonItem?.isEnabled = !inputIsEmpty
        
        textViewPlaceholder.isHidden = !infoTextView.text.isEmpty
    }
    
    private func editMode(_ activate: Bool) {
        let color = activate ? view.tintColor : UIColor.black
        let secondaryColor = activate ? view.tintColor : UIColor.darkGray
        
        setupInputContent(isEditing: activate)
        
        titleTextField.isEnabled = activate
        costTextField.isEnabled = activate
        infoTextView.isEditable = activate
        urlTextField.isEnabled = activate
        
        titleTextField.textColor = color
        costTextField.textColor = color
        infoTextView.textColor = secondaryColor
        urlTextField.textColor = color
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItemTouch))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditItemTouch))
        
        navigationItem.rightBarButtonItem = activate ? doneButton : editButton
        
        changeButtonState()
    }
    
}


// MARK: - UITextFieldDelegate

extension ItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
}


// MARK: - UITextViewDelegate

extension ItemViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changeButtonState()
    }
    
}
