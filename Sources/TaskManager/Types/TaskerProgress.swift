//
//  TaskerProgress.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 5/1/25.
//

import Foundation

public enum TaskerProgress {
    case done
    case almostDone
    case canceling
    case progressAbsolute(Double)
    case progress(Int, Int)
    case autoProgressTotal(Int)
    case undefined
}
