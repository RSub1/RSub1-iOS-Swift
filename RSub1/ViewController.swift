//
//  ViewController.swift
//  RSub1
//
//  Created by Alexandru Petrescu on 21.03.20.
//  Copyright © 2020 RSub1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func activeButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowTracker", sender: self)
    }
}

