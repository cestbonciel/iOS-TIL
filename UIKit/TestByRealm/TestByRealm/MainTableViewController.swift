//
//  MainTableViewController.swift
//  TestByRealm
//
//  Created by Nat Kim on 2024/02/15.
//

import UIKit

import RealmSwift

class MainTableViewController: UITableViewController {
    let realm = try! Realm()
    
    private let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    private let editBarButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: nil, action: nil)
    private let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
    
    private var itemArray: Results<TodoThingsData>?
    
    private var isDelete = false
    private var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureTableView()
        configureBarButtonAction()
        
        realmGetData()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
//        populateDummyData()
    }
    
    private func realmGetData() {
        itemArray = realm.objects(TodoThingsData.self).sorted(byKeyPath: "name", ascending: true)
    }
    
    private var titleTextField = UITextField()
    private var categoryTextField = UITextField()
    
    private var selectedCategory: Category = Category.uncategorized
    
    lazy private var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        return picker
    }()
    
    private func configureNavigationItem() {
        navigationItem.title = "To-Do List"
        navigationItem.setRightBarButtonItems([addBarButton], animated: true)
        navigationItem.setLeftBarButtonItems([deleteBarButton, editBarButton], animated: true)
    }
    
    private func configureBarButtonAction() {
        addBarButton.target = self
        addBarButton.action = #selector(addButtonPressed)
        editBarButton.target = self
        editBarButton.action = #selector(editButtonPressed)
        deleteBarButton.target = self
        deleteBarButton.action = #selector(deleteButtonPressed)
    }
    
    // Register the custom cell
    private func configureTableView() {
        tableView.register(DataTableViewCell.self, forCellReuseIdentifier: DataTableViewCell.identifier)
    }
    
    // Create dummy data
//    private func populateDummyData() {
//        for i in 0...Category.allCases.count-1 {
//            let data = Data(name: "Data \(i)", category: Category.allCases[i])
//            itemArray.append(data)
//        }
//    }
    
    private func realmAdd(data: TodoThingsData) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error saving data \(error)")
        }
    }
        
    @objc private func addButtonPressed() {
        
        // Create a new alert
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // Add alert action
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // Title text field validation
            guard let safeTitleTextFieldValue = self.titleTextField.text else { return }
            if safeTitleTextFieldValue.isEmpty { return }
            
            // Category text field validation
            guard let safeCategoryTextFieldValue = self.categoryTextField.text else { return }
            if safeCategoryTextFieldValue.isEmpty { self.selectedCategory = Category.uncategorized }
            
            let newItemData = TodoThingsData(name: safeTitleTextFieldValue, category: self.selectedCategory)
//            self.itemArray.append(newItemData)
            self.realmAdd(data: newItemData)
            self.tableView.reloadData()
        }
        
        // Add title text field
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "What are you planning to do?"
            self.titleTextField = alertTextField
        }
        
        // Add category text field
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Category"
            alertTextField.inputView = self.pickerView // Show the picker when tapping the category input field
            self.categoryTextField = alertTextField
        }
        
        // Add action to the alert
        alert.addAction(addAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    @objc func editButtonPressed() {
        // Toggle edit mode
        isEdit = !isEdit
        isDelete = false
        
        deleteBarButton.isEnabled = !isEdit
        addBarButton.isEnabled = !isEdit
    }

    @objc func deleteButtonPressed() {
        // Toggle delete mode
        isDelete = !isDelete
        isEdit = false
        
        editBarButton.isEnabled = !isDelete
        addBarButton.isEnabled = !isDelete
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier, for: indexPath) as! DataTableViewCell
        cell.data = itemArray?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isEdit {
            editCell(cellAtRow: indexPath.row)
        } else if isDelete {
            deleteCell(cellAtRow: indexPath.row)
        } else {
            toggleCheckmark(indexPath: indexPath)
        }
    }
    
    func editCell(cellAtRow: Int) {
        
        // Create a new alert
        let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
        
        // Add alert action
        let applyAction = UIAlertAction(title: "Apply", style: .default) { action in
            
            // Title text field validation
            guard let safeTitleTextFieldValue = self.titleTextField.text else { return }
            if safeTitleTextFieldValue.isEmpty { return }
            
            // Category text field validation
            guard let safeCategoryTextFieldValue = self.categoryTextField.text else { return }
            self.selectedCategory = Category(rawValue: safeCategoryTextFieldValue) ?? Category.uncategorized
            
            do {
                try self.realm.write {
                    self.itemArray?[cellAtRow].category = self.selectedCategory.rawValue
                    self.itemArray?[cellAtRow].isChecked = self.itemArray?[cellAtRow].isChecked ?? false
                    
                    self.itemArray?[cellAtRow].name = safeTitleTextFieldValue
                }
            } catch {
                print("Error edit item: \(error)")
            }
//            let newItemData = Data(name: safeTitleTextFieldValue, category: self.selectedCategory, isChecked: self.itemArray[cellAtRow].isChecked)
//            self.itemArray[cellAtRow] = newItemData
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add title text field
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "What are you planning to do?"
            alertTextField.text = self.itemArray?[cellAtRow].name
            self.titleTextField = alertTextField
        }
        
        // Add category text field
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Category"
            alertTextField.text = self.itemArray?[cellAtRow].category
            alertTextField.inputView = self.pickerView // Show the picker when tapping the category input field
            self.categoryTextField = alertTextField
        }
        
        // Add action to the alert
        alert.addAction(applyAction)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func deleteCell(cellAtRow: Int) {
        guard let cellData = itemArray?[cellAtRow] else { return }
        // Create a new alert
//        let alert = UIAlertController(title: "Delete Item?", message: "\(itemArray[cellAtRow].name)\n\(itemArray[cellAtRow].category.rawValue)", preferredStyle: .alert)
        let alert = UIAlertController(title: "Delete Item?", message: "\(cellData.name)\n\(cellData.category)", preferredStyle: .alert)
        
        // Add alert action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            //self.itemArray.remove(at: cellAtRow)
            // Delete data with realm
            do {
                try self.realm.write {
                    self.realm.delete(cellData)
                }
            } catch {
                print("Error delete data: \(error)")
            }
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add action to the alert
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
}

extension MainTableViewController: DataTableViewCellDelegate {
    func toggleCheckmark(indexPath: IndexPath) {
        let row = indexPath.row
        guard let isChecked = itemArray?[row].isChecked else { return }
        
        // Update data with realm
        do {
            try realm.write {
                itemArray?[row].isChecked = !isChecked
                
                let cell = tableView.cellForRow(at: indexPath) as! DataTableViewCell
                cell.getCheckmarkImage.isHidden = isChecked
            }
        } catch {
            print("Error in toggle checkmark: \(error)")
        }
    }
    
    
}

extension MainTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = Category.allCases[row]
        categoryTextField.text = selectedCategory.rawValue
    }
    
}
