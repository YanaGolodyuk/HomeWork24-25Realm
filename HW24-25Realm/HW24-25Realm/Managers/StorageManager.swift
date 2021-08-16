//
//  StorageManager.swift
//  HW24-25Realm
//
//  Created by admin on 12.08.2021.
//

import Foundation
import RealmSwift

let relam = try! Realm()

class StorageManager {
    
    static func deleteAll() {
        try! relam.write{
            relam.deleteAll()
        }
    }
    
    static func saveTasksList(taskList: TasksList) {
        try! relam.write{
            relam.add(taskList)
        }
    }
    
    static func deleteList(_ tasksList: TasksList) {
        try! relam.write{
            let tasks = tasksList.tasks
            
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    static func editList(_ tasksList: TasksList, newListName: String) {
        try! relam.write{
            tasksList.name = newListName
        }
    }
    
    static func makeAllDone(_ tasksList: TasksList) {
        try! relam.write{
            tasksList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    static func saveTask(_ tasksList: TasksList, task: Task) {
        try! relam.write {
            tasksList.tasks.append(task)
        }
    }
    
    static func editTask(_ task: Task, newNameTask: String, newNote: String) {
        try! relam.write {
            task.name = newNameTask
            task.note = newNote
        }
    }
    
    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func makeDone(_ task: Task) {
        try! realm.write {
            task.isComplete.toggle()
        }
    }
}
