//
//  ViewController.swift
//  Login Test
//
//  Created by Adrien Maranville on 3/16/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var isLoggedIn = false

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBAction func btnSubmitPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if isLoggedIn {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            do {
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        result.setValue(inputName.text, forKey: "name")
                        
                        do {
                            try context.save()
                        } catch {
                            print("Update username save failed")
                        }
                        
                    }
                lblMessage.text = "Welcome " + inputName.text! + "!"
                }
            } catch {
                print("Update username failed")
            }
        } else {
            let newValue = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
            newValue.setValue(inputName.text, forKey: "name")
            do {
                try context.save()
                lblUsername.text = "Update username"
                lblMessage.alpha = 1
                lblMessage.text = "Welcome " + inputName.text! + "!"
                btnLogOut.alpha = 1
                btnSubmit.setTitle("Update", for: [])
                
                isLoggedIn = true
            } catch {
                print("Failed to save")
            }
            
        }
        
    }
    
    @IBOutlet weak var btnLogOut: UIButton!
    @IBAction func btnLogOutPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                    do {
                        try context.save()
                    } catch {
                        print("Individual delete failed.")
                    }
                }
                lblUsername.text = "Enter username"
                lblMessage.alpha = 0
                btnLogOut.alpha = 0
                btnSubmit.setTitle("Submit", for: [])
                inputName.alpha = 1
                btnSubmit.alpha = 1
                lblUsername.alpha = 1
                
                isLoggedIn = false

            }
        } catch {
            print("Delete failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                if let username = result.value(forKey: "name") as? String {
                    lblUsername.text = "Update username"
                    lblMessage.alpha = 1
                    lblMessage.text = "Welcome " + username + "!"
                    btnLogOut.alpha = 1
                    btnSubmit.setTitle("Update", for: [])
                    isLoggedIn = true
                }
            }
        } catch {
            print("Request failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

