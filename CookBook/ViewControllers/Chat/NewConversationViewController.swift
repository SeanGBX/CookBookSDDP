//
//  NewConversationViewController.swift
//  CookBook
//
//  Created by ITP312Grp2 on 1/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class NewConversationViewController: UIViewController{

    public var completion: ((Profile) -> (Void))?
    // test
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users : [Profile] = []
    private var results: [Profile] = []
    
    let currUserId = Auth.auth().currentUser!.uid
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        
        return label
    }()
    
    func addSearchBar(){
        navigationItem.searchController = searchController
        navigationController?.navigationBar.topItem?.title = "Users"
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.placeholder = "Search..."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        didPresentSearchController(searchController)
    }
    
    func didPresentSearchController(_ searchController1: UISearchController) {
        searchController1.searchBar.becomeFirstResponder()
    }
    
    func loadUsers(){
        chatDataManager.loadChat(currUserId){
            UserListFromFirestore in
            
            self.users = UserListFromFirestore
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        addSearchBar()
        loadUsers()
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        noResultsLabel.frame = CGRect(x: view.frame.width/4, y: (view.frame.height-200)/2, width: view.frame.width/2, height: 100)
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespaces)
        results = users.filter { (following : Profile) -> Bool in
            return following.displayName.lowercased().contains(text.lowercased())
        }
        if text == ""{
            results = users
        }
        updateUI()
        tableView.reloadData()
        
    }
    func updateUI(){
        if results.isEmpty && isFiltering{
            view.addSubview(noResultsLabel)
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
            
        }
        else{
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
        }
    }
    

    
    
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return results.count
        }
        if !isFiltering{
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let p : Profile
        
        if isFiltering {
            p = results[indexPath.row]
        }
        else{
            p = users[indexPath.row]
            
        }
        cell.textLabel?.text = p.displayName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUser : Profile
        if isFiltering{
            targetUser = results[indexPath.row]
            dismissSelf()
        }
        else{
            targetUser = users[indexPath.row]
        }
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUser)
        })

    }
}

extension NewConversationViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

