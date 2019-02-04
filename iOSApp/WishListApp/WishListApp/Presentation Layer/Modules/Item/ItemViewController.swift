//
//  ItemViewController.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit


// MARK: - Enum for edit mode

enum ViewMode {
    case edit
    case add
}


// MARK: - ItemViewController

class ItemViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var costLabel: UITextField!
    @IBOutlet weak var infoView: UITextView!
    @IBOutlet weak var urlLabel: UITextField!
    
    // MARK: - Private variables
    
    private let wishlistManager: IWishlistManager
    private var item: ItemModel
    private var mode: ViewMode
    
    // MARK: - Calculated variables
    
    private var modifiedItem: ItemModel? {
        get {
            guard let newName = titleLabel.text == self.item.name ? "" : titleLabel.text else { return nil }
            guard let newInfo = infoView.text == self.item.comment ? "" : infoView.text else { return nil}
            guard let newUrl = urlLabel.text == self.item.url ? "" : urlLabel.text else { return nil }
            
            guard let costString = costLabel.text else { return nil }
            guard let newCost = Int(costString) == self.item.cost ? self.item.cost : Int(costString) else { return nil }
            
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
        titleLabel.text = item.name
        infoView.text = item.comment
        costLabel.text = String(item.cost) 
        urlLabel.text = item.url
        
        titleLabel.delegate = self
        infoView.delegate = self
        costLabel.delegate = self
        urlLabel.delegate = self
        
        infoView.textContainerInset = UIEdgeInsets.zero
        infoView.textContainer.lineFragmentPadding = 0
    }
    
    private func setupKeyboardAppearance() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        self.item = item
        
        switch mode {
        case .add:
            wishlistManager.addItem(item: item) { (success) in
                print("Success add item: \(success)")
                self.mode = .edit
            }
        case .edit:
            wishlistManager.editItem(item: item) { (success) in
                print("Success edit save: \(success)")
            }
        }
        
        editMode(false)
    }
    
    
    // MARK: - Private functions
    
    private func editMode(_ activate: Bool) {
        let color = activate ? view.tintColor : UIColor.black
        let secondaryColor = activate ? view.tintColor : UIColor.darkGray
        
        titleLabel.isEnabled = activate
        costLabel.isEnabled = activate
        infoView.isEditable = activate
        urlLabel.isEnabled = activate
        
        titleLabel.textColor = color
        costLabel.textColor = color
        infoView.textColor = secondaryColor
        urlLabel.textColor = color
        
        guard let costString = costLabel.text else { return }
        costLabel.text = activate ? String(item.cost) : costString + "$"
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItemTouch))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditItemTouch))
        
        navigationItem.rightBarButtonItem = activate ? doneButton : editButton
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
    
}
