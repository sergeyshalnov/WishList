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
    
    private let presentationAssembly: IPresentationAssembly
    private let wishlistManager: IWishlistManager
    
    private let cellIdentifier = String(describing: ItemCell.self)
    private var itemsCount: Int = 0
    
    // RefreshControl setup
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    // MARK: - Initialization
    
    init(presentationAssembly: IPresentationAssembly, wishlistManager: IWishlistManager) {
        self.presentationAssembly = presentationAssembly
        self.wishlistManager = wishlistManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableViewData()
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
        
        itemsTableView.refreshControl = refreshControl
    }
    
    private func setupWishlistManager() {
        //
    }
    
    
    // MARK: - Button functions
    
    @objc private func addTapped() {
        let item = ItemModel(id: 0, name: "", comment: "", cost: 0, url: "")
        let itemController = presentationAssembly.Item(item: item, mode: .add)
        
        navigationController?.pushViewController(itemController, animated: true)
    }
    
    // MARK: - Refresh control function
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        reloadTableViewData()
    }
    
    
    // MARK: - Reload TableView Data
    
    private func reloadTableViewData() {
        wishlistManager.performeRequest { (count) -> (Void) in
            DispatchQueue.main.async {
                self.itemsCount = count
                self.itemsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    // MARK: - Private functions
    
    private func deleteItem(index: IndexPath, id: Int) {
        wishlistManager.deleteItem(id: id) { (success) in
            if success {
                self.itemsCount -= 1
                DispatchQueue.main.async {
                    self.itemsTableView.deleteRows(at: [index], with: .automatic)
                }
            } else {
                let alert = Alert.controller(type: .deleteError)
                self.present(alert, animated: true, completion: nil)
            }

            print("Delete item: \(success)")
        }
    }


}

// MARK: - UITableViewDelegate extension

extension ItemsListViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = wishlistManager.getItem(index: indexPath.row)
        let itemController = presentationAssembly.Item(item: item, mode: .edit)
        
        navigationController?.pushViewController(itemController, animated: true)
    }
    
}


// MARK: - UITableViewDataSource extension

extension ItemsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let itemCell = tableView.cellForRow(at: indexPath) as? ItemCell else { return }
            guard let itemId = itemCell.id else { return }
            
            deleteItem(index: indexPath, id: itemId)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = itemsTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        
        let item = wishlistManager.getItem(index: indexPath.row)
        
        cell.id = item.id
        cell.titleLabel.text = item.name
        cell.informationLabel.text = item.comment
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}
