//
//  DetailViewController.swift
//  AdventureFinder
//
//  Created by Wayne Bangert on 3/29/16.
//  Copyright © 2016 Wayne Bangert. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    var detailItem:Any? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {}
    

}
