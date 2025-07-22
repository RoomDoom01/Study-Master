//
//  CanvasLoginView.swift
//  Study Master
//
//  Created by Finley Room on 7/15/25.
//

import SwiftUI

struct LoginView: View{
    @EnvironmentObject var session: SessionManager
    
    var body: some View{
        VStack(spacing: 24) {
                    Text("Welcome to Study Master")
                        .font(.title)
                        .bold()
                    if !session.canvasLoggedIn{
                        Text("Please login to your canvas in order to populate calendar")
                            .font(.title3)
                        //add canvas login logic
                        Button("Login"){
                            session.canvasLogin(with: "temp")
                        }
                    }
                    else if !session.familyControlsLoggedIn{
                        Text("Please login to family controls in order to restrict apps")
                        Button("Login"){
                            session.familyControlsLogin()
                        }
                    }
                    else{
                        Text("All Logged In!")
                    }
                }
                .padding()
    }
}
