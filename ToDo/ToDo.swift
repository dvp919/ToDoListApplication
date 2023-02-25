//
//  ToDo.swift
//  ToDo
//
//  Created by Dhruv Patel.
//

import Foundation
class ToDo {
    var taskName: String = ""
    var isUrgent: Bool
    var isComplete: Bool
    var taskDate : Date
    
    
    init(task : String, urgent: Bool, complete: Bool, date : Date){
        self.taskName = task
        self.isUrgent = urgent
        self.taskDate = date
        self.isComplete = complete
    }
}
