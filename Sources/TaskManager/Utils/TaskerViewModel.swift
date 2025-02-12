//
//  TaskerViewModel.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 5/1/25.
//

import Foundation
import Combine


@MainActor
public class TaskerViewModel: Combine.ObservableObject {
    public static let s = TaskerViewModel()
    @Published public var isBusy = false
    @Published public var progress: Double = 0
    @Published public var error: String = ""
    @Published public var message: String = "Cargando..."
    @Published public var showProgressBar: Bool = false
    @Published public var isProgressPresented: Bool = false
    @Published public var isErrorPresented: Bool = false
    
    @Published public var isQuestionDialogPresented: Bool = false
    @Published public var dialogResponse: Bool? = nil
    @Published public var dialogType: TaskerDialogs = .success
    
    public var showNoButton: Bool {
        switch dialogType {
        case .alert, .info, .warning, .error, .success:
            return false
        case .yesNo(_, _):
            return true
        case .yesNoCancel(_, _, _):
            return true
        }
    }
    
    public var showCancelButton: Bool {
        switch dialogType {
        case .alert, .info, .warning, .error, .success:
            return false
        case .yesNo(_, _):
            return false
        case .yesNoCancel(_, _, _):
            return true
        }
    }
    
    public var yesButtonText: String {
        switch dialogType {
        case .alert, .info, .warning, .error, .success:
            return "Aceptar"
        case .yesNo(let yes, _):
            return yes ?? "Sí"
        case .yesNoCancel(let yes, _, _):
            return yes ?? "Sí"
        }
    }
    
    public var noButtonText: String {
        switch dialogType {
        case .alert, .info, .warning, .error, .success:
            return ""
        case .yesNo(_, let no):
            return no ?? "No"
        case .yesNoCancel(_, let no, _):
            return no ?? "No"
        }

    }
    
    public var cancelButtonText: String {
        switch dialogType {
        case .alert, .info, .warning, .error, .success:
            return ""
        case .yesNo(_, _):
            return ""
        case .yesNoCancel(_, _, let cancel):
            return cancel ?? "Cancelar"
        }
    }
    
    
    public func waitNotBusy() async{
        for await value in $isBusy.values {
            if value == false {
                return
            }
        }
    }
    
    public func questionDialogClose() async {
        for await value in $isQuestionDialogPresented.values {
            if value == false {
                return
            }
        }
    }
    
    public func getTitle() -> String {
        switch dialogType {
        case .success:
            return "Exito"
        case .error:
            return "Error"
        case .warning:
            return "Advertencia"
        case .alert:
            return "Alerta"
        case .info:
            return "Información"
        case .yesNo(_,_):
            return "Pregunta"
        case .yesNoCancel(_,_,_):
            return "Pregunta"
        }
    }
    
    
    
    
    public func showDialog(mensaje: String, type: TaskerDialogs = .success) async -> Bool? {
        await waitNotBusy()
        message = mensaje
        dialogType = type

        isQuestionDialogPresented = true
        
        await questionDialogClose()
        
        return dialogResponse
    }
    
    public func startProgress(isProgressUndefined: Bool, showBlockindicator: Bool) {
        isBusy = true
        progress = 0
        self.showProgressBar = !isProgressUndefined
        if showBlockindicator {
            isProgressPresented = true
        }
    }
    
    public func stopProgress() {
        isBusy = false
        progress = 0
        isProgressPresented = false
    }
    
    public func setProgress(_ progress: Double) {
        self.progress = progress
    }
    
    public func setMessage(_ message: String) {
        self.message = message
    }
    
    public func setError(_ error: String) {
        isBusy = false
        isProgressPresented = false
        
        self.error = error
        isErrorPresented = true
    }
    
    private init() {}
}
