final class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool

    init() {
        isLoggedIn = KeychainHelper.shared.read(forKey: "canvasAccessToken") != nil
    }

    func logout() {
        KeychainHelper.shared.delete(forKey: "canvasAccessToken")
        isLoggedIn = false
    }

    func completeLogin(with token: String) {
        KeychainHelper.shared.save(token, forKey: "canvasAccessToken")
        isLoggedIn = true
    }

    func getToken() -> String? {
        return KeychainHelper.shared.read(forKey: "canvasAccessToken")
    }
}