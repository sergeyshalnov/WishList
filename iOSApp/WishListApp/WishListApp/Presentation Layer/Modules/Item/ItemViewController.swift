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
    
    private let name: String
    private let cost: String
    private let info: String
    private let url: String
    
    // MARK: - Initialization
    
    init(name: String, cost: Int, info: String, url: String, wishlistManager: IWishlistManager) {
        self.name = name.uppercased()
        self.cost = String(cost) + "$"
        self.info = info.capitalized
        self.url = url
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
        titleLabel.text = name
        infoView.text = info
        costLabel.text = cost
        urlLabel.text = url
        
        infoView.textContainerInset = UIEdgeInsets.zero
        infoView.textContainer.lineFragmentPadding = 0
    }
    
    
    // MARK: - Button functions
    
    @objc private func editItemTouch() {
        editMode(true)
    }
    
    @objc private func endEditItemTouch() {
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
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItemTouch))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditItemTouch))
        
        navigationItem.rightBarButtonItem = activate ? doneButton : editButton
    }
    
    
    
}
