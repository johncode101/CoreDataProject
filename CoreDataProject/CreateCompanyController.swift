//
//  CreateCompanyController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 3/26/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: NewCompanies)
}

class CreateCompanyController: UITableViewController {
    
    var delegate: CreateCompanyControllerDelegate?
        
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Names"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
            
        tableView.backgroundColor = UIColor.darkBlue
                    
        tableView.separatorColor = .white
            
        tableView.tableFooterView = UIView()
            
        navigationItem.title = "Create Company"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        setupNavigationStyle()
        
        setupUI()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
    }
    
    @objc private func handleSave() {
        
        // This line of code bring the persistent container stack on to the handle save func
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        // this line inserts the companies data into coredata
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "NewCompanies", into: context)
        
        // and this saves the name thats put onto the textfield onto coredata
        
        company.setValue(nameTextField.text, forKey: "name")
        
        //This lines of code are the saving structure
        
        do {
            try context.save()
            
            //success
            
            dismiss(animated: true, completion: {self.delegate?.didAddCompany(company: company as! NewCompanies)
                
            })
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
        
    }
    
    private func setupUI() {
        
        let lightBlueBackGroundView = UIView()
        
        view.addSubview(lightBlueBackGroundView)
        
        lightBlueBackGroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        lightBlueBackGroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackGroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackGroundView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        lightBlueBackGroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(nameTextField)
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        
    }
    
    
    @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
        
    }
}

extension UIViewController {
    
        func setupNavigationStyle() {
        
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .darkBlue
        appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white] //portrait title
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white] //landscape title
        navigationController?.navigationBar.standardAppearance = appearance //landscape
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance //portrait    }
        
    }
}
