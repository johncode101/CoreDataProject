//
//  CreateCompanyController.swift
//  CoreDataProject
//
//  Created by Jonathan Hernandez on 3/26/20.
//  Copyright © 2020 Jonathan Hernandez. All rights reserved.
//

import UIKit
import CoreData

//This line of code is where you declare the createCompanycontrolDelegate to be passed on to the viewcontroller

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: NewCompanies)
    func didEditCompany(company: NewCompanies)
}

class CreateCompanyController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //This lines of code pass the info from viewontroller to createcompanycontroller
    var company: NewCompanies? {
        didSet {
            nameTextField.text = company?.name
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
                setUpCircularImageStyle()
            }
            
            guard let founded = company?.founded else { return }
            
            datePicker.date = founded
        }
    }
    
    private func setUpCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.lightRed.cgColor
        companyImageView.layer.borderWidth = 2
        
    }
    
    var delegate: CreateCompanyControllerDelegate?
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()
    
    @objc private func handleSelectPhoto() {
        print("Trying to select photo..")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]
            as? UIImage {
            
            companyImageView.image = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        setUpCircularImageStyle()
        dismiss(animated: true, completion: nil)
    }
        
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
            
        tableView.backgroundColor = UIColor.darkBlue
                    
        tableView.separatorColor = .white
            
        tableView.tableFooterView = UIView()
                    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        setupNavigationStyle()
        
        setupUI()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
    }
    
    @objc private func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChages()
        }
        
    }
    
    private func saveCompanyChages() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.imageData = imageData
        }

        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didEditCompany(company: self.company!)
            })
        }catch let saveErr {
            print("Failed to save company changes", saveErr)
        }
    }
    
    private func createCompany() {
                
        // This line of code bring the persistent container stack on to the handle save func
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        // this line inserts the companies data into coredata
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "NewCompanies", into: context)
        
        // and this saves the name thats put onto the textfield onto coredata
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        //This lines of code are the saving structure
        
        do {
            try context.save()
            
            //success
            
            dismiss(animated: true, completion: {self.delegate?.didAddCompany(company: company as! NewCompanies)
                
            })
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }    }
    
    private func setupUI() {
        
        let lightBlueBackGroundView = UIView()
        
        view.addSubview(lightBlueBackGroundView)
        
        lightBlueBackGroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        lightBlueBackGroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackGroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackGroundView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        lightBlueBackGroundView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        

        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackGroundView.bottomAnchor).isActive = true
        
        
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
