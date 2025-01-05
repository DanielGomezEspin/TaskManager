//
//  ProgressDialog.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/1/25.
//

import SwiftUI

public struct ProgressDialog: View {
    @Binding var mensaje: String
    @Binding var progress: Double
    var showProgressBar: Bool = true
    var onCancel: () -> Void
    
    @State private var isCanceling = false
    
    public var body: some View {
        VStack(spacing: 20) {
            if showProgressBar {
                ProgressBar(value: progress)
                    .frame(height: 20)
            }
            HStack {
                ProgressView()
                    .controlSize(.small)
                    .scaleEffect(0.8)
                    .padding(.vertical, 2)
                Text(isCanceling ? "Cancelando..." : mensaje)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Spacer()
                Button("Cancelar") {
                    isCanceling = true
                    onCancel()
                }
                .disabled(isCanceling)
            }
        }
        .padding()
        .frame(width: 300, height: 150)
        
    }
}

