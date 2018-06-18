//
//  FullScreenViewController.swift
//  ImageApp
//
//  Created by Alanda Syla on 11/4/17.
//  Copyright © 2017 Alanda Syla. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Varables
    var image: UIImage!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    func loadImage() {
        self.imageView.image = image
    }
    
    //MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension FullScreenViewController {
    static func create() -> FullScreenViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
    }
}
