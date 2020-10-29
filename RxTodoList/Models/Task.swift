//
//  Task.swift
//  RxTodoList
//
//  Created by Bharath Raj Kumar B on 29/10/20.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
