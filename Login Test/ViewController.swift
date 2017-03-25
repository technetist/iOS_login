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

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBAction func btnSubmitPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newValue = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        newValue.setValue(inputName.text, forKey: "name")
        do {
            try context.save()
            inputName.alpha = 0
            btnSubmit.alpha = 0
            lblUsername.alpha = 0
            lblMessage.alpha = 1
            lblMessage.text = "Welcome " + inputName.text! + "!"
        } catch {
            print("Failed to save")
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
                    inputName.alpha = 0
                    btnSubmit.alpha = 0
                    lblUsername.alpha = 0
                    lblMessage.alpha = 1
                    lblMessage.text = "Welcome " + username + "!"
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

