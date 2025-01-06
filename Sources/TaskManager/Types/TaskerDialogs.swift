//
//  TaskerDialogs.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 5/1/25.
//

import Foundation

public enum TaskerDialogs: Sendable {
    case alert
    case info
    case warning
    case error
    case success
    case yesNo(String? = nil, String? = nil)
    case yesNoCancel(String? = nil, String? = nil, String? = nil)
}
