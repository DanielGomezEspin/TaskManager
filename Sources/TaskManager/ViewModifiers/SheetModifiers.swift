//
//  SheetModifiers.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/1/25.
//
import SwiftUI



public struct TaskProgressModifier: ViewModifier {
    @StateObject private var taskerVM = TaskerViewModel.s
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $taskerVM.isProgressPresented) {
                ProgressDialog(mensaje: $taskerVM.message, progress: $taskerVM.progress, showProgressBar: taskerVM.showProgressBar) {
                    Task{
                        await Tasker.shared.cancel()
                    }
                }
            }
            .sheet(isPresented: $taskerVM.isErrorPresented){
                ErrorDialog(mensaje: $taskerVM.error) {
                    taskerVM.isErrorPresented = false
                }
            }
            .sheet(isPresented: $taskerVM.isQuestionDialogPresented){
                ConfirmationDialog(
                    title: taskerVM.getTitle(),
                    message: taskerVM.message,
                    showCancelButton: taskerVM.showCancelButton,
                    showNoButton: taskerVM.showNoButton,
                    yesButtonText: taskerVM.yesButtonText,
                    noButtonText: taskerVM.noButtonText,
                    cancelButtonText: taskerVM.cancelButtonText,
                                   onYes: {
                    taskerVM.dialogResponse = true
                    taskerVM.isQuestionDialogPresented = false
                },
                                   onNo: {
                    taskerVM.dialogResponse = false
                    taskerVM.isQuestionDialogPresented = false
                },
                                   onCancel: {
                    taskerVM.dialogResponse = nil
                    taskerVM.isQuestionDialogPresented = false
                    
                })
            }
        
    }
}

public struct TaskerDisableIfBusyModifier: ViewModifier {
    @StateObject private var taskerVM = TaskerViewModel.s
    
    public func body(content: Content) -> some View {
        content
            .disabled(taskerVM.isBusy)
    }
}



public extension View {
    
    func taskerDialogs() -> some View {
        modifier(TaskProgressModifier())
    }
    
    func disableIfBusy() -> some View {
        modifier(TaskerDisableIfBusyModifier())
    }
    
    
}



