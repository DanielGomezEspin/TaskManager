//
//  ConfirmationDialog.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/1/25.
//

import SwiftUI

public struct ConfirmationDialog: View {
    var title: String
    var message: String
    
    var showCancelButton: Bool = false
    var showNoButton: Bool = false

    var yesButtonText = "Aceptar"
    var noButtonText = "No"
    var cancelButtonText = "Cancelar"


    var onYes: () -> Void
    var onNo: () -> Void
    var onCancel: () -> Void
    
   
    public var body: some View {
        
        
        VStack(spacing: 20) {
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                if showCancelButton {
                    Button(cancelButtonText) {
                        onCancel()
                    }
                }
                if showNoButton {
                    Button(noButtonText) {
                        onNo()
                    }
                }

                Button(yesButtonText) {
                    onYes()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .frame(width: 300)
    }
}
