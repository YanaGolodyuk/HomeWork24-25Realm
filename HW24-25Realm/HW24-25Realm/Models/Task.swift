//
//  Task.swift
//  HW24-25Realm
//
//  Created by admin on 12.08.2021.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var data = Date()
    @objc dynamic var isComplete = false
}
