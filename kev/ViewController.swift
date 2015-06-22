//
//  ViewController.swift
//  kev
//
//  Created by Peter Akuhata on 22/06/15.
//  Copyright (c) 2015 Peter Akuhata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var kevView: KevView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTouchWalkButton(sender: UIButton) {
        self.kevView.addWalkingAnimation()
    }

    @IBAction func didTouchFadeInButton(sender: UIButton) {
        self.kevView.addFadeInAnimation()
    }
}

