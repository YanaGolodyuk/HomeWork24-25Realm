//
//  TasksList.swift
//  HW24-25Realm
//
//  Created by admin on 12.08.2021.
//

import Foundation
import RealmSwift

class TasksList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
