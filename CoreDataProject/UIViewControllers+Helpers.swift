//
//  UIViewControllers+Helpers.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 4/21/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    func setUpPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setUpCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
}
