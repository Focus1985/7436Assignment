//
//  LoginViewController.swift
//  HelpByDrone
//
//  Created by Focus on 22/10/19.
//  Copyright © 2019 Focus. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    let networkService = NetworkingService()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboard()
    }
    
    
    
    @IBAction func tapLogin(_ sender: UIButton) {
        guard
            let username = Username.text,
            let password = Password.text
            else { return}
        let parameters = ["username": username, "password": password]
        networkService.request(endpoint: "/login", parameters: parameters, completion: {[weak self](success) in
            if success {
                self?.performSegue(withIdentifier: "LoginSegue", sender: sender)
                print(success)
            } else {
                print("Incrrect username or password")
            }
        })
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
