//
//  FocusModeView.swift
//  Study Master
//
//  Created by Finley Room on 7/13/25.
//

import SwiftUI

struct FocusModeView: View {
    @State private var isFocusModeActive = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(isFocusModeActive ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: isFocusModeActive ? "lock.shield.fill" : "lock.shield")
                        .font(.system(size: 50))
                        .foregroundColor(isFocusModeActive ? .red : .gray)
                }
                
                VStack(spacing: 16) {
                    Text(isFocusModeActive ? "Focus Mode Active" : "Focus Mode")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(isFocusModeActive ?
                         "Your phone is locked. Stay focused on your studies!" :
                         "Block distracting apps and notifications to maintain deep focus during study sessions.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isFocusModeActive.toggle()
                    }
                }) {
                    Text(isFocusModeActive ? "End Focus Session" : "Start Focus Session")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFocusModeActive ? Color.red : Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                
                if isFocusModeActive {
                    VStack(spacing: 8) {
                        Text("Session Duration")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("25:00")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Focus Mode")
            .background(.regularMaterial)
        }
    }
}
