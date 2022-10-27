//
//  ViewController.swift
//  AlefDevelopment
//
//  Created by Никита Кочетов on 24.10.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IB Outelts
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var kidsTableView: UITableView!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var addKidButton: UIButton!
    
    // MARK: - Private properties
    private var tableData = [
        (kidName: "Петр", kidAge: "13")
    ]{
        didSet {
            if tableData.count == 5 {
                addKidButton.isHidden = true
            } else {
                addKidButton.isHidden = false
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IB Actions
    @IBAction func addKidButtonPressed(_ sender: UIButton) {
        kidsTableView.isHidden = false
        clearButton.isHidden = false
        
        self.tableData.append((kidName: "", kidAge: ""))
        self.kidsTableView.performBatchUpdates {
            self.kidsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
        }
    }
    
    @IBAction func deleteChildButtonPressed(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: kidsTableView)
        guard let indexpath = kidsTableView.indexPathForRow(at: point) else {return}
        tableData.remove(at: indexpath.row)
        kidsTableView.beginUpdates()
        kidsTableView.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .right)
        kidsTableView.endUpdates()
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let clearAction = UIAlertAction(title: "Очистить все", style: .default) { _ in
            self.tableData = []
            self.kidsTableView.reloadData()
            sender.isHidden = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(clearAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet,animated: true)
    }
    
    // MARK: - Private Methods
   private func setupUI(){
       kidsTableView.isHidden = true
       clearButton.isHidden = true
       tableData = []
       clearButton.setTitle("Очистить", for: .normal)
    }
}

// MARK: - Table View Delegate and Data Source
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let row = indexPath.row
        
        cell.nameTextField.text = tableData[row].kidName
        cell.nameTextField.placeholder = "Имя"
        cell.ageTextField?.text = tableData[row].kidAge
        cell.ageTextField.placeholder = "Возраст"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Text Field Delegate
extension MainViewController: UITextFieldDelegate {
    //Скрываем клавиатуру по нажатию Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
