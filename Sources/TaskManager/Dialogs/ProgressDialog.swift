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
            
            AppIconImageView(name: NSImage.applicationIconName)
                            .padding()
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
        .frame(width: 300)
        
    }
}


// Vista reutilizable para el icono de la app
struct AppIconImageView: View {
    let size: CGFloat = 64
    let name: NSImage.Name
    
    var body: some View {
        Group {
            if let appIcon = NSImage(named: name) {
                Image(nsImage: appIcon)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            } else {
                // Fallback si no se encuentra el icono
                Image(systemName: "app.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundColor(.gray)
            }
        }
    }
}


