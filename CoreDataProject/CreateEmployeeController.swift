//
//  CreateEmployeeController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 4/21/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UITableViewController {
    
    var company: NewCompanies?
    
    var delegate: CreateEmployeeControllerDelegate?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/DD/YYYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        
        setupNavigationStyle()

        setUpCancelButton()
        
        view.backgroundColor = .darkBlue
                
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = self.company else { return }
        
        //turn birtdahyTextField.text into a date object
        
        guard let birthdayText = birthdayTextField.text else { return }
        
        //lets perform the validation step here
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "You have not entered a birthday.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YYYY"
        
        guard let birthdaydate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad date", message: "Birthday date entered not valid")
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
//        print(employeeType)
                
        //where do we get newcompanies from
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, birthday: birthdaydate, employeeType: employeeType, company: company)
        if let error = tuple.1 {
            print(error)
        } else {
            //creation success
            dismiss(animated: true, completion: {
                // we'll call the delagate somehow
                self.delegate?.didAddEmployee(employee: tuple.0!)
            })
        }
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    let employeeTypeSegmentedControl: UISegmentedControl = {
//        let types = ["Executive", "Senior Management", "Staff"]
        
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManagemnt.rawValue,
            EmployeeType.Staff.rawValue,
            EmployeeType.Intern.rawValue
        ]
        
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.darkBlue
        return sc
    }()
    
    private func setupUI() {
        
        _ = setupLightBlueBackgroundView(height: 150)
        
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
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //align it with the birthdaytextfield
        view.addSubview(birthdayTextField)
        birthdayTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        
        
        view.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 0).isActive = true
        employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
    }
    
}







