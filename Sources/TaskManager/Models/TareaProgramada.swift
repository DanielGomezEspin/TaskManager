//
//  TareaProgramada.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/2/25.
//

import Foundation

// Tipo para reportar progreso
public typealias ProgressReporter = @Sendable (String, TaskerProgress) async throws -> Void
// Tipo de closure para la tarea larga que recibe una función para reportar progreso
public typealias TaskWithProgress = @Sendable (ProgressReporter) async throws -> Void


public enum TaskStatus {
    case finalizada
    case cancelada
    case error(Error)
}




final class TareaProgramada: Sendable {
    let id: UUID
    let name: String
    let tarea: TaskWithProgress
    let mensaje: String
    let showBlockindicator: Bool
    let isUndefined: Bool
    let cancelPrevious: Bool
    
    init(id: UUID, name: String, tarea: @escaping TaskWithProgress, mensaje: String, showBlockindicator: Bool, isUndefined: Bool, cancelPrevious: Bool) {
        self.id = id
        self.name = name
        self.tarea = tarea
        self.mensaje = mensaje
        self.showBlockindicator = showBlockindicator
        self.isUndefined = isUndefined
        self.cancelPrevious = cancelPrevious
    }
    
    init(){
        self.id = UUID()
        self.name = ""
        self.tarea = { _ in }
        self.mensaje = ""
        self.showBlockindicator = false
        self.isUndefined = false
        self.cancelPrevious = false
    }
}
