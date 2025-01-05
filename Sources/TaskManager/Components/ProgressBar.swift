//
//  ProgressBar.swift
//  TaskManager
//
//  Created by Daniel Gomez Espin on 4/1/25.
//

import SwiftUI

public struct ProgressBar: View {
    var value: Double
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: geometry.size.width * value)
                HStack {
                    Spacer()
                    Text("\(Int(value * 100))%")
                    Spacer()
                }
                    

            }
            .cornerRadius(5)
        }
    }
}

