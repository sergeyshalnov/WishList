//
//  ItemViewController.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var costLabel: UITextField!
    @IBOutlet weak var infoView: UITextView!
    @IBOutlet weak var urlLabel: UITextField!
    
    // MARK: - Private variables
    
    private let wishlistManager: IWishlistManager
    private var item: ItemModel
    
    
    // MARK: - Initialization
    
    init(item: ItemModel, wishlistManager: IWishlistManager) {
        self.item = item
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
        setupNavigationController()
        setupLabels()
    }
    
    private func setupNavigationController() {
        editMode(false)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupLabels() {
        titleLabel.text = item.name
        infoView.text = item.comment
        costLabel.text = String(item.cost) + "$"
        urlLabel.text = item.url
        
        infoView.textContainerInset = UIEdgeInsets.zero
        infoView.textContainer.lineFragmentPadding = 0
    }
    
    
    // MARK: - Button functions
    
    @objc private func editItemTouch() {
        editMode(true)
    }
    
    @objc private func endEditItemTouch() {
        guard let newName = titleLabel.text == self.item.name ? "" : titleLabel.text else { return }
        guard let newInfo = infoView.text == self.item.comment ? "" : infoView.text else { return }
        guard let newUrl = urlLabel.text == self.item.url ? "" : urlLabel.text else { return }
        
        guard let costString = costLabel.text else { return }
        guard let newCost = Int(costString) == self.item.cost ? self.item.cost : Int(costString) else { return }
        
        let item = ItemModel(id: self.item.id, name: newName, comment: newInfo, cost: newCost, url: newUrl)
        self.item = item
        
        wishlistManager.editItem(item: item) { (success) in
            print("Success edit save: \(success)")
        }
        
        editMode(false)
    }
    
    
    // MARK: - Private functions
    
    private func editMode(_ activate: Bool) {
        let color = activate ? view.tintColor : UIColor.black
        let secondaryColor = activate ? view.tintColor : UIColor.darkText
        
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
