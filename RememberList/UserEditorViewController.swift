//
//  UserEditorViewController.swift
//  RememberList
//
//  Created by Gabriel Blaine Palmer on 1/7/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit
import CoreData

class UserEditorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adultCheckbox: UIImageView!
    @IBOutlet weak var childCheckbox: UIImageView!
    
    var userController: UserController?
    var user: User?
    var adultSelected: Bool = true
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            nameTextField.text = user.name
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func adultCheckboxTapped(_ sender: UITapGestureRecognizer) {
        if !adultSelected {
            adultSelected = true
            adultCheckbox.image = UIImage(named: "checked")
            childCheckbox.image = UIImage(named: "unchecked")
        }
    }
    
    @IBAction func childCheckboxTapped(_ sender: UITapGestureRecognizer) {
        if adultSelected {
            adultSelected = false
            adultCheckbox.image = UIImage(named: "unchecked")
            childCheckbox.image = UIImage(named: "checked")
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
        
        performSegue(withIdentifier: "exitSegue", sender: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("EditPersonViewController is not in navigation controller")
        }
    }
    
}
