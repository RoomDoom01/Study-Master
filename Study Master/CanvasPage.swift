//
// CanvasPage.swift
// Study Master
//
// Created by Dakota Chou on 7/16/2025
//

import Foundation
import SwiftUI

struct CanvasAssignment: Identifiable {
    let id: String
    let title: String
    let dueAt: Date?
    let type: ItemType

    enum ItemType {
        case assignment
        case quiz
    }
}

@MainActor
class CanvasViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var assignments: [CanvasAssignment] = []
    @Published var isLoading = false

    private let clientID = "YOUR_CLIENT_ID" //needs to be changed
    private let redirectURI = "myapp://oauth-callback" // needs to be changed
    private let canvasDomain = "https://canvas.instructure.com"

    func checkLoginStatus() {
        isLoggedIn = UserDefaults.standard.string(forKey: "canvasAccessToken") != nil
        if isLoggedIn {
            fetchPlannerItems()
        }
    }

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

    func fetchPlannerItems() {
        guard let token = UserDefaults.standard.string(forKey: "canvasAccessToken"),
              let url = URL(string: "\(canvasDomain)/api/v1/planner/items?start_date=\(ISO8601DateFormatter().string(from: Date()))") else { return }

        isLoading = true

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            defer { Task { @MainActor in self.isLoading = false } }

            guard let data = data,
                  let rawItems = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }

            let formatter = ISO8601DateFormatter()

            let parsedAssignments = rawItems.compactMap { item -> CanvasAssignment? in
                guard let id = item["plannable_id"] as? Int,
                      let plannable = item["plannable"] as? [String: Any],
                      let title = plannable["title"] as? String else { return nil }

                let dueAt: Date? = {
                    if let dueString = plannable["due_at"] as? String {
                        return formatter.date(from: dueString)
                    }
                    return nil
                }()

                return CanvasAssignment(id: String(id), title: title, dueAt: dueAt)
            }

            DispatchQueue.main.async {
                self.assignments = parsedAssignments
            }
        }.resume()
    }
}