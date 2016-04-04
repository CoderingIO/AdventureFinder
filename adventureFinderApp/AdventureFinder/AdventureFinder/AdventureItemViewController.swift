//
//  AdventureItemViewController.swift
//  AdventureFinder
//
//  Created by Wayne Bangert on 3/24/16.
//  Copyright © 2016 Wayne Bangert. All rights reserved.
//

import UIKit

class AdventureItemViewController: DetailViewController {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var descriptionTextField: UITextView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var ratingControl: RatingControl?
    
    @IBOutlet weak var navBar:UINavigationBar?
    
    
    override func configureView() {
        guard let adventure = self.detailItem as? AdventureItem? where placeNameLabel != nil else {return}
        
        placeNameLabel?.text = adventure!.name
        navigationItem.title = adventure!.name
        ratingLabel?.text = "Awesome"
        addressLabel?.text = adventure!.address
        descriptionTextField?.text = "Description Here"
        ratingControl?.rating = adventure!.rating
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backButton = UIButton(type: UIButtonType.RoundedRect)
//        backButton.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//        backButton.backgroundColor = UIColor.redColor()
//        backButton.setTitle("BacK", forState: UIControlState.Normal)
//        backButton.addTarget(self, action: #selector(backTouched), forControlEvents: UIControlEvents.TouchUpInside)
//        
//        self.navBar!.addSubview(backButton)
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backTouched(sender:UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
