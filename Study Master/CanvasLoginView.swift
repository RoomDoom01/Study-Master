//
//  CanvasLoginView.swift
//  Study Master
//
//  Created by Finley Room on 7/15/25.
//

import SwiftUI

struct CanvasLoginView: View{
    var passToken: (String) -> Void
    
    var body: some View{
        VStack(spacing: 24) {
                    Text("Welcome to Study Master")
                        .font(.title)
                        .bold()

                    Text("Please log in to your Canvas account to continue.")
                        .multilineTextAlignment(.center)

                    Button("Log in with Canvas") {
                        // Launch your OAuth flow here
                        // For now, simulate login:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            let fakeToken = "abc123-token-from-canvas"
                            passToken(fakeToken)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
    }
}
