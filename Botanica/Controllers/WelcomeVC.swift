//
//  WelcomeVC.swift
//  Botanica
//
//  Created by yekta on 3.02.2024.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var contiuneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        contiuneButton.layer.cornerRadius = 20
        contiuneButton.layer.masksToBounds = true
    }
    
    @IBAction func contiuneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toMainPageVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainPageVC" {
            if segue.destination is ViewController{
                // data
            }
        }
    }
    
}

