//
//  CanvasLoginView.swift
//  Study Master
//
//  Created by Finley Room on 7/14/25.
//
import SwiftUI

struct AppEntryView: View{
    @StateObject private var session = SessionManager()
    var body: some View{
        if session.isLoggedIn {
            ContentView()
        }
        else{
            //later change this to check which services they're logged into and either offer or force the login to specific ones.
            CanvasLoginView(){
                token in session.completeLogin(with: token)
            }
        }
    }
}
