//
// CanvasPage.swift
// Study Master
//
// Created by Dakota Chou on 7/16/2025
//

import Foundation
import SwiftUI


@MainActor
class CanvasViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var assignments: [CanvasAssignment] = []
    @Published var isLoading = false

    private let clientID = "YOUR_CLIENT_ID" //needs to be changed
    private let redirectURI = "myapp://oauth-callback" // needs to be changed
    private let canvasDomain = "https://canvas.instructure.com"

    

    func startOAuthFlow() {
        guard let url = URL(string: "\(canvasDomain)/login/oauth2/auth?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)") else { return }
        UIApplication.shared.open(url)
    }

    func handleOAuthCallback(url: URL) {
        guard let code = URLComponents(string: url.absoluteString)?
                .queryItems?.first(where: { $0.name == "code" })?.value else { return }

        exchangeCodeForToken(code: code)
    }

    private func exchangeCodeForToken(code: String) {
        guard let url = URL(string: "\(canvasDomain)/login/oauth2/token") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "grant_type=authorization_code&client_id=\(clientID)&client_secret=YOUR_CLIENT_SECRET&redirect_uri=\(redirectURI)&code=\(code)"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let token = json["access_token"] as? String else { return }

            UserDefaults.standard.set(token, forKey: "canvasAccessToken")

            DispatchQueue.main.async {
                self.isLoggedIn = true
                self.fetchPlannerItems()
            }
        }.resume()
    }
}