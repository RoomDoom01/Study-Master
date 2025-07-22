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
        if session.isLoggedIn() {
            ContentView()
        }
        else{
            LoginView()
        }
    }
}
