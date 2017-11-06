//
//  ImageZoomingViewController.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 06/11/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class ImageZoomingViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Actions
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    

}



