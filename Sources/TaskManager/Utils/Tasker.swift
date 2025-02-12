//
//  RunningTask.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/1/25.
//

import Foundation




public actor Tasker {
    public static let shared = Tasker()
    private init(){
    }
    
    private var runningTaskTask: Task<Void, Error>?
    private var runningTareaProgramada: TareaProgramada = TareaProgramada()
    private var numTotalIteraciones = 0
    private var iteracionActual = 0
    private var isExecuting = false

    
    private struct TaskWaiter {
        let id: UUID
        let continuation: CheckedContinuation<Void, Never>
    }
    
    // Añade esta propiedad para almacenar las esperas
    private var waiters: [TaskWaiter] = []

    private func wakeup(for id: UUID) {
        // Notificar a los waiters que están esperando esta tarea
        let waitersForThisTask = waiters.filter { $0.id == id }
        waiters.removeAll { $0.id == id }
        
        // Resumir todas las continuaciones para esta tarea
        for waiter in waitersForThisTask {
            waiter.continuation.resume()
        }
    }

    
    // Añade la función para esperar por una tarea específica
    public func waitForTask(id: UUID) async {
        // Si la tarea no está en la cola ni ejecutándose, retornamos finalizada
        guard tareas.contains(where: { $0.id == id }) || runningTareaProgramada.id == id else {
            return
        }
        
        await withCheckedContinuation { continuation in
            waiters.append(TaskWaiter(id: id, continuation: continuation))
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    /* cola tareas */
    private var tareas: [TareaProgramada] = []
    
    public func addTask(function: String, id: UUID, mensaje: String, showBlockindicator: Bool = true, isUndefined: Bool = false, cancelPrevious: Bool = false, taskToExecute: @escaping TaskWithProgress) async {
        // eliminar todas las tareas que estén en la cola con el mismo nombre y no han empezado
        removeTask(name: function)
        // cancela la tarea en ejecución si es la misma que estamos intentando encolar
        if cancelPrevious == true {
            await cancel(name: function)
        }
        let tarea: TareaProgramada = TareaProgramada(id: id, name: function, tarea: taskToExecute, mensaje: mensaje, showBlockindicator: showBlockindicator, isUndefined: isUndefined, cancelPrevious: cancelPrevious)
        
        tareas.append(tarea)
        if !isExecuting {
            Task {
                await executeNextTask()
            }
        }
        
        print("                                 ADD  \(tarea.name)  tarea:\(tarea.id) : \(tareas.count)")
        await waitForTask(id: tarea.id)
    }
    
    
    
    
    
    
    
    
    
    private func removeTask(name: String) {
        tareas.filter { $0.name == name }.forEach { wakeup(for: $0.id) }
        tareas.removeAll(where: {$0.name == name})
    }
    private func removeTask(id: UUID) {
        tareas.filter { $0.id == id }.forEach { wakeup(for: $0.id) }
        tareas.removeAll(where: {$0.id == id})
    }

    /* cola tareas*/
    
    private func executeNextTask() async {
        guard !tareas.isEmpty && !isExecuting else {
            return
        }
        
        isExecuting = true
        while !tareas.isEmpty {
            runningTareaProgramada = tareas.removeFirst()
            // Ejecuta la tarea
            print("INICIO \(runningTareaProgramada.name) - \(runningTareaProgramada.id) : \(tareas.count)")
            let resultado = await self.execute(mensaje: runningTareaProgramada.mensaje, showBlockindicator: runningTareaProgramada.showBlockindicator, isUndefined: runningTareaProgramada.isUndefined, taskToExecute: runningTareaProgramada.tarea)

            wakeup(for: runningTareaProgramada.id)
            
            switch resultado {
            case .finalizada:
                print("FIN    \(runningTareaProgramada.name) - \(runningTareaProgramada.id)  : \(tareas.count)")
            case .cancelada:
                print("CANCEL \(runningTareaProgramada.name) - \(runningTareaProgramada.id)  : \(tareas.count)")
            case .error(let error):
                print("ERROR  \(runningTareaProgramada.name) - \(runningTareaProgramada.id)  : \(tareas.count) : \(error.localizedDescription)")
            }
            
        }
        isExecuting = false
    }
    
    
    
    
    private func execute(mensaje: String, showBlockindicator: Bool = true, isUndefined: Bool = false, taskToExecute: @escaping TaskWithProgress) async -> TaskStatus {
        
        runningTaskTask = Task {
            
            
            await TaskerViewModel.s.startProgress(isProgressUndefined: isUndefined, showBlockindicator: showBlockindicator)
            
            numTotalIteraciones = 0
            iteracionActual = 0
            
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
        var resultado: TaskStatus
        
        do{
            try await runningTaskTask?.value
            resultado = .finalizada
        } catch is CancellationError {
            resultado = .cancelada
        } catch {
            await TaskerViewModel.s.setError(error.localizedDescription)
            resultado = .error(error)
        }
        
        await TaskerViewModel.s.stopProgress()
        
        return resultado
    }

    
    
    
    
    
    
    public func cancel() async {
        runningTaskTask?.cancel()
        try? await runningTaskTask?.value
        
    }
    
    public func cancelById(_ id: UUID) async {
        // eliminar todas las de la cola con ese id
        removeTask(id: id)

        guard runningTareaProgramada.id == id else { return }
        await cancel()
    }

    private func cancel(name: String) async {

        guard runningTareaProgramada.name == name else { return }
        await cancel()
    }
    
    
    
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

}

