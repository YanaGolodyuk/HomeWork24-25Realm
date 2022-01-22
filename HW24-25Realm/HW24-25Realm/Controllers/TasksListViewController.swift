//
//  TasksListViewController.swift
//  HW24-25Realm
//
//  Created by admin on 12.08.2021.
//

import UIKit
import RealmSwift

let realm = try! Realm()

class TasksListViewController: UITableViewController {

    var tasksLists: Results<TasksList>!
    var notificationToken: NotificationToken?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Clean Realn DB
//        StorageManager.deleteAll()
        
        tasksLists = realm.objects(TasksList.self).sorted(byKeyPath: "name")
        
        notificationToken = tasksLists.observe { change in
            switch change {
            case .initial:
                print("initial")
            case .update(_, let deletions, let insertions, let modifications):
                print("deletions: \(deletions)")
                print("insertions: \(insertions)")
                print("modifications: \(modifications)")
            case .error(let error):
                print(error)
            }
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        alertForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let tasksList = tasksLists[indexPath.row]
//        cell.textLabel?.text = tasksList.name
//        cell.detailTextLabel?.text = String(tasksList.tasks.count)
        cell.configure(with: tasksList)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deleteCotextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editeCotextItem = UIContextualAction(style: .destructive, title: "Edite") { _, _, _ in
            self.alertForAddAndUpdateList(currentList, complition: {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
        
        let doneCotextItem = UIContextualAction(style: .destructive, title: "Done") { _, _, _ in
            StorageManager.makeAllDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        editeCotextItem.backgroundColor = .orange
        doneCotextItem.backgroundColor = .green
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteCotextItem, editeCotextItem, doneCotextItem])
        
        return swipeActions
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.currentTasksList = tasksList
        }
    }


//    private func alertForAddAndUpdateList() {
//
//        let title = "New List"
//        let massage = "Pleaase insert list name"
//
//        let doneButtonName = "Save"
//
//        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
//        var alertTextField: UITextField!
//
//        let saveAction = UIAlertAction(title: doneButtonName, style:  .default) { _ in
//            guard let newList = alertTextField.text, !newList.isEmpty else { return }
//
//            let taskList = TasksList()
//            taskList.name = newList
//
//            StorageManager.saveTasksList(taskList: taskList)
//            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
//
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//
//        alert.addTextField { textField in
//            alertTextField = textField
//            alertTextField.placeholder = "List name"
//        }
//
//        present(alert, animated: true)
//    }
    
    private func alertForAddAndUpdateList(_ tasksList: TasksList? = nil, complition: (() -> Void)? = nil) {
        
        let title = tasksList == nil ? "New List" : "Edit List"
        let massage = "Pleaase insert list name"
        let doneButtonName = tasksList == nil ? "Save" : "Update"
        
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtonName, style:  .default) { _ in
            guard let newListName = alertTextField.text, !newListName.isEmpty else { return }
            
            if let tasksList = tasksList {
                StorageManager.editList(tasksList, newListName: newListName)
                if let complition = complition {
                    complition()
                }
            } else {
                let tasksList = TasksList()
                tasksList.name = newListName
                
                StorageManager.saveTasksList(taskList: tasksList)
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List name"
        }
        
        if let listName = tasksList {
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
    }
}
