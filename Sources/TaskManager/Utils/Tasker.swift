//
//  RunningTask.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/1/25.
//

import Foundation

// Tipo para reportar progreso
public typealias ProgressReporter = @Sendable (String, TaskerProgress) async throws -> Void
// Tipo de closure para la tarea larga que recibe una función para reportar progreso
public typealias TaskWithProgress = @Sendable (ProgressReporter) async throws -> Void

public protocol Tasking {
    func createTask(mensaje: String, isUndefined: Bool, cancelPrevious: Bool, taskToExecute: @escaping TaskWithProgress) async
    func showDialog(mensaje: String, type: TaskerDialogs) async -> Bool?
    func cancelTask() async
}

public extension Tasking {
    func createTask(mensaje: String = "Cargando...", isUndefined: Bool = false, cancelPrevious: Bool = false, taskToExecute: @escaping TaskWithProgress) async {
        await Tasker.shared.start(mensaje: mensaje, isUndefined: isUndefined, cancelPrevious: cancelPrevious, taskToExecute: taskToExecute)
    }
    func showDialog(mensaje: String, type: TaskerDialogs = .success) async -> Bool? {
        return await Tasker.shared.showDialog(mensaje: mensaje, type: type)
    }
    func cancelTask() async{
        await Tasker.shared.cancel()
    }
}


public actor Tasker {
    public static let shared = Tasker()
    private init(){
    }
    
    
    private var runningTask: Task<Void, Error>?
    private var numTotalIteraciones = 0
    private var iteracionActual = 0
 
    
    public func showDialog(mensaje: String, type: TaskerDialogs = .success) async -> Bool? {

        return await TaskerViewModel.s.showDialog(mensaje: mensaje, type: type)
    }
    
    public func setNumTotalIteraciones(_ numTotalIteraciones: Int) {
        self.numTotalIteraciones = numTotalIteraciones
    }
    public func setIteracionActual(_ iteracionActual: Int) {
        self.iteracionActual = iteracionActual
    }
    public func incrementIteracionActual() {
        iteracionActual += 1
    }
    
    public func resetProgress(_ total: Int = 0){
        numTotalIteraciones = total
        iteracionActual = 0
    }
    
    public func start(mensaje: String = "Cargando...", isUndefined: Bool = false, cancelPrevious: Bool = false, taskToExecute: @escaping TaskWithProgress) async {
        
        if await TaskerViewModel.s.isBusy && cancelPrevious == true {
            runningTask?.cancel()
        }
        
        
        await TaskerViewModel.s.waitNotBusy()
        
        await TaskerViewModel.s.startProgress(isProgressUndefined: isUndefined)

        numTotalIteraciones = 0
        iteracionActual = 0

        
        runningTask = Task {
            try await taskToExecute({ mensaje, progress in
                
                try Task.checkCancellation()
                
                switch progress {
                case .almostDone:
                    await TaskerViewModel.s.setProgress(0.99)
                case .done:
                    await TaskerViewModel.s.setProgress(1.0)
                case .canceling:
                    await TaskerViewModel.s.setProgress(0.0)
                case .undefined:
                    await TaskerViewModel.s.setProgress(0.0)
                    await resetProgress()
                case .progressAbsolute(let absoluteValue):
                    await TaskerViewModel.s.setProgress(absoluteValue)
                case .progress(let iteration, let total):
                    await TaskerViewModel.s.setProgress(Double(iteration) / Double(total))
                case .autoProgressTotal(let total):
                    let nonisoltatedTotal = await numTotalIteraciones
                    if nonisoltatedTotal == 0 || nonisoltatedTotal != total {
                        await resetProgress(total)
                    }
                    await incrementIteracionActual()
                    if await numTotalIteraciones != 0 {
                        await TaskerViewModel.s.setProgress(Double(iteracionActual) / Double(numTotalIteraciones))
                    }else{
                        await TaskerViewModel.s.setProgress(0.0)
                    }
                    
                }
                
                await TaskerViewModel.s.setMessage(mensaje)
            })
        }
        
        
        do{
            try await runningTask?.value
        } catch is CancellationError {
        } catch {
            await TaskerViewModel.s.setError(error.localizedDescription)
        }
        
        runningTask = nil
        
        await TaskerViewModel.s.stopProgress()
        
    }
    
    
    
    public func cancel() {
        runningTask?.cancel()
        runningTask = nil
    }
}
