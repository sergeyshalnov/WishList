//
//  ItemsViewController.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

class ItemsListViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    
    // MARK: - Private variables
    
    private let wishlistManager: IWishlistManager
    private let cellIdentifier = String(describing: ItemCell.self)
    
    private var itemsCount: Int = 0
    // private var items: [ItemModel] = []
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init(wishlistManager: IWishlistManager) {
        self.wishlistManager = wishlistManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupWishlistManager()
    }
    
    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = rightButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.title = "Wishlist"
    }
    
    private func setupTableView() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        itemsTableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupWishlistManager() {
        wishlistManager.performeRequest { (count) -> (Void) in
            DispatchQueue.main.async {
                self.itemsCount = count
                self.itemsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Button functions
    
    @objc private func addTapped() {
        
    }


}

// MARK: - UITableViewDelegate extension

extension ItemsListViewController: UITableViewDelegate {
 
    // ---
    
}


// MARK: - UITableViewDataSource extension

extension ItemsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = itemsTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        
        let item = wishlistManager.getItem(index: indexPath.row)
        
        cell.titleLabel.text = item.name
        cell.informationLabel.text = item.comment
        cell.costLabel.text = String(item.cost)
        
        return cell
    }
    
    
}
