//
//  UsersTableViewController.swift
//  RememberList
//
//  Created by Gabriel Blaine Palmer on 1/7/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit
import CoreData

class UsersTableViewController: UITableViewController {
    
    let userController = UserController()
    
    var users = [User]()
    var currentFilter: FilterOption = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = userController.fetchUsers(for: currentFilter)
    }

    //========================================
    // MARK: - Table view data source
    //========================================

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch currentFilter {
        case .none:
            return nil
        case .adults:
            return "Adults"
        case .children:
            return "Children"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        if user.isAdult {
            cell.detailTextLabel?.text = "Adult"
        } else {
            cell.detailTextLabel?.text = "Child"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userController.deleteUser(user: users.remove(at: indexPath.row))
            userController.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //========================================
    // MARK: - Filtering
    //========================================
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Filter For...",
            message: nil,
            preferredStyle: .actionSheet)
        
        let adultAction = UIAlertAction(title: "Adults", style: .default) { (_) in
            if self.currentFilter != .adults {
                self.filterChanged(filter: .adults)
            }
        }
        
        let childAction = UIAlertAction(title: "Children", style: .default) { (_) in
            if self.currentFilter != .children {
                self.filterChanged(filter: .children)
            }
        }
        
        let defaultAction = UIAlertAction(title: "No Filter", style: .default) { (_) in
            if self.currentFilter != .none {
                self.filterChanged(filter: .none)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(adultAction)
        alertController.addAction(childAction)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func filterChanged(filter: FilterOption) {
        currentFilter = filter
        users = userController.fetchUsers(for: currentFilter)
        tableView.reloadData()
    }
    
    //========================================
    // MARK: - Navigation
    //========================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "editUser":
            guard let destination = segue.destination as? UserEditorViewController else { fatalError() }
            
            destination.navigationItem.title = "Edit User"
            destination.userController = userController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.user = users[indexPath.row]
            } else {
                fatalError("cell was not being displayed")
            }
            
        case "addUser":
            guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? UserEditorViewController else { fatalError() }
            destination.navigationItem.title = "New User"
            destination.userController = userController
            destination.user = nil
        default:
            fatalError("Unexpect segue")
        }
    }
    
    @IBAction func unwindFromUserEditor(segue: UIStoryboardSegue) {
        guard let source = segue.source as? UserEditorViewController else { fatalError() }
        
        //update users array if new entity was added
        if source.user == nil {
            users = userController.fetchUsers(for: currentFilter)
        }
        
        tableView.reloadData()
    }
    
}
