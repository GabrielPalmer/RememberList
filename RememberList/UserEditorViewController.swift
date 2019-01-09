//
//  UserEditorViewController.swift
//  RememberList
//
//  Created by Gabriel Blaine Palmer on 1/7/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit
import CoreData

protocol UserEditorProtocol {
    func updateUsers(user: User?)
}

class UserEditorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adultCheckbox: UIImageView!
    @IBOutlet weak var childCheckbox: UIImageView!
    
    var userController: UserController?
    var delegate: UserEditorProtocol?
    var user: User?
    var adultSelected: Bool = true
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.isEnabled = false
        
        if let user = user {
            nameTextField.text = user.name
            adultSelected = user.isAdult
            updateCheckboxes()
        }
    }
    
    func dismissView() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("EditPersonViewController is not in navigation controller")
        }
    }
    
    func updateCheckboxes() {
        if adultSelected {
            adultCheckbox.image = UIImage(named: "checked")
            childCheckbox.image = UIImage(named: "unchecked")
        } else {
            adultCheckbox.image = UIImage(named: "unchecked")
            childCheckbox.image = UIImage(named: "checked")
        }
        
        
    }
    
    @IBAction func adultCheckboxTapped(_ sender: UITapGestureRecognizer) {
        if !adultSelected {
            adultSelected = true
            updateCheckboxes()
        }
    }
    
    @IBAction func childCheckboxTapped(_ sender: UITapGestureRecognizer) {
        if adultSelected {
            adultSelected = false
            updateCheckboxes()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func nameTextFieldWasEdited(_ sender: UITextField) {
        if (sender.text ?? "").isEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let userController = userController, let name = nameTextField.text {
            if user == nil {
                userController.createUser(name: name, isAdult: adultSelected)
            } else if let user = user {
                user.name = nameTextField.text
                user.isAdult = adultSelected
            }
            
            userController.save()
        }
        
        delegate?.updateUsers(user: user)
        dismissView()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }
    
}
