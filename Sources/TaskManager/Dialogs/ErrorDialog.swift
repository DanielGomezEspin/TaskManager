//
//  ErrorDialog.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/1/25.
//

import SwiftUI

public struct ErrorDialog: View {
    @Binding var mensaje: String
    var onOk: () -> Void


    public var body: some View {
        VStack(spacing: 20) {
            Text("Error")
                .font(.title)

            Text(mensaje)
            Button("Ok") {
                onOk()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


