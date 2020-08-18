//
//  ChatViewController.swift
//  CookBook
//
//  Created by Sean Gwee on 28/6/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var convList : [Conversations] = []
    var followingList : [Profile] = []
    private var results: [Conversations] = []
    private var following: [Followers] = []
    
    let currUserId = Auth.auth().currentUser!.uid
    
    private let spinner = JGProgressHUD(style: .dark)
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //View for when there is no results in search
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        
        return label
    }()
    
    var isFiltering: Bool {
        //check if the user is searching
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var isSearchBarEmpty: Bool {
        //check if the searchbar is empty
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        //filter the list if it appears in the search
        let text = searchText.trimmingCharacters(in: .whitespaces)
        results = convList.filter { (conv: Conversations) -> Bool in
            if conv.firstUserId == currUserId{
                return conv.secondUserName.lowercased().contains(text.lowercased())
            }
            else{
                return conv.firstUserName.lowercased().contains(text.lowercased())
            }
        }
        if text == ""{
            results = convList
        }
        updateUI()
        tableView.reloadData()
        
    }
    func updateUI(){
        // If the results is empty show is hidden label view
        if results.isEmpty && isFiltering{
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        }
        else{
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    func addSearchBar(){
        // Programically add searchbar
        navigationItem.searchController = searchController
        let searchField = searchController.searchBar.searchTextField
        searchField.backgroundColor = .systemBackground
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    func loadChat(){
        chatDataManager.loadConversations(currUserId){
            convListFromFirestore in
            
            self.convList = convListFromFirestore
            
            self.tableView.reloadData()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.title = "Messages"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemIndigo
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        addSearchBar()
        view.addSubview(noResultsLabel)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKey))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        spinner.show(in: view)
        startListeningForConversation()
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //load following
        followDataManager.loadFollowing(currUserId) {
            Following in
            self.following = Following
            chatDataManager.loadChat(self.currUserId, self.following){
                UserListFromFirestore in
                self.followingList = UserListFromFirestore
                
                self.tableView.reloadData()
            }
        }
        self.spinner.dismiss()
    }
    
    override func viewDidLayoutSubviews() {
        //Configure noresultlabel ui
        super.viewDidLayoutSubviews()
        noResultsLabel.frame = CGRect(x: view.frame.width/4, y: (view.frame.height-200)/2, width: view.frame.width/2, height: 100)
    }
    
    private func startListeningForConversation(){
        //Conversation observer
        chatDataManager.getAllListenConversation(currUserId){
            convListFromFirestore in
            
            self.convList = convListFromFirestore
            
            self.tableView.reloadData()
        }
        self.spinner.dismiss()
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        //Edit button
        self.tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing{
            self.editButton.title = "Done"
        }
        else{
            self.editButton.title = "Edit"
        }
    }
    
    @objc func dismissKey() {
        // Dismiss keyboard
        view.endEditing(true)
    }
    
    @objc private func didTapComposeButton(){
        //Add conversations
        let vc = NewConversationViewController()
        vc.completion = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createNewConversation(result: Profile){
        //Push FriendDetailViewController
        let vc = FriendDetailViewController()
        var resultconv : Conversations?
        vc.followingList = result
        vc.navigationItem.largeTitleDisplayMode = .never
        
        chatDataManager.loadSpecificChat(result.UID, currUserId){
            //Load chat with id
            specificConv in
            resultconv = specificConv
            
            
        }
        chatDataManager.findSpecificChat(result.UID, currUserId){
            //Check if chat exists in db
            isSuccessful in
            if isSuccessful{
                vc.isNewConversation = false
                vc.convItems = resultconv
                self.navigationController?.pushViewController(vc, animated: true)
            }	
            else{
                vc.isNewConversation = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Deleting using table view
        if editingStyle == .delete
        {
            let conv = convList[indexPath.row]
            
            var otherUserId = ""
            if conv.firstUserId != currUserId{
                otherUserId = conv.firstUserId
            }
            else{
                otherUserId = conv.secondUserId
                
            }
            convList.remove(at: indexPath.row)
            chatDataManager.deleteConv(otherUserId, currUserId)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return results.count
        }
        if !isFiltering{
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
        }
        return convList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure tabel cell UI
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let p : Conversations
        let countOfList: Int
        if isFiltering {
            p = results[indexPath.row]
            countOfList = results[indexPath.row].messages.count
        }
        else{
            p = convList[indexPath.row]
            countOfList = convList[indexPath.row].messages.count
            
        }
        if p.firstUserId != currUserId{
            cell.friendnameLabel.text = p.firstUserName
            cell.friendImage.kf.setImage(with: URL(string: p.firstImage), placeholder: UIImage(named: "defaultprofile"))
        }
        else{
            cell.friendnameLabel.text = p.secondUserName
            cell.friendImage.kf.setImage(with: URL(string: p.secondImage), placeholder: UIImage(named: "defaultprofile"))
        }
        
        cell.friendtextLabel.text = p.messages[countOfList - 1]["message"]
        cell.friendImage.layer.borderWidth = 1
        cell.friendImage.layer.masksToBounds = false
        cell.friendImage.layer.borderColor = UIColor.black.cgColor
        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.height/2
        cell.friendImage.clipsToBounds = true
        
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?)
    {
        //ShowFriendDetail segue
        if(segue.identifier == "ShowFriendDetails")
        {
            let detailViewController = segue.destination as! FriendDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil)
            {
                let convs = convList[myIndexPath!.row]
                detailViewController.convItems = convs
            }
        }
        
    }
    
    
}

extension ChatViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

