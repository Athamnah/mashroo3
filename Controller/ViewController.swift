//
//  ViewController.swift
//  mashroo3
//
//  Created by Omar Warrayat on 07/02/1446 AH.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func signInTap(_ sender: Any) {
        let singVC = self.storyboard?.instantiateViewController(withIdentifier: "signInViewController") as! signInViewController
        self.navigationController?.pushViewController(singVC , animated: true)
    }
    @IBAction func signUpTap(_ sender: Any) {
        let singVC = self.storyboard?.instantiateViewController(withIdentifier: "signUpViewController") as! signUpViewController
        self.navigationController?.pushViewController(singVC , animated: true)
    }

    @IBAction func loginAsGuest(_ sender: UIButton) {
        let singVC = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
        self.navigationController?.pushViewController(singVC , animated: true)
    }
    
}

