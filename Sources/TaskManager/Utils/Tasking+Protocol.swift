//
//  Tasker+Protocol.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/2/25.
//

import Foundation

public protocol Tasking {
    func createTask(function: String, id: UUID, mensaje: String, showBlockindicator: Bool, isUndefined: Bool, cancelPrevious: Bool, taskToExecute: @escaping TaskWithProgress) async
    
    func cancelById(_ id: UUID?) async

    func showDialog(mensaje: String, type: TaskerDialogs) async -> Bool?

}

public extension Tasking {
    func createTask(function: String = #function, id: UUID = UUID(), mensaje: String = "Cargando...", showBlockindicator: Bool = true, isUndefined: Bool = false, cancelPrevious: Bool = false, taskToExecute: @escaping TaskWithProgress) async {
        await Tasker.shared.addTask(function: function, id: id, mensaje: mensaje, showBlockindicator: showBlockindicator, isUndefined: isUndefined, cancelPrevious: cancelPrevious, taskToExecute: taskToExecute)
    }
    
    func cancelById(_ id: UUID?) async {
        guard let id = id else { return }
        await Tasker.shared.cancelById(id)
    }

    func showDialog(mensaje: String, type: TaskerDialogs = .success) async -> Bool? {
        return await Tasker.shared.showDialog(mensaje: mensaje, type: type)
    }
}
