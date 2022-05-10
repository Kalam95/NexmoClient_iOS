//
//  LoginViewController.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 01.05.22.
//

import UIKit
import NexmoClient

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!

    let client = NXMClient.shared
    let neworkLayer: NetworkLayer = .init()
    private var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        client.logout()
    }

    @IBAction func loginButtonTapped() {
        sendUserRequest(atEndpoint: "login")
    }

    @IBAction func signupButtonTapped() {
        sendUserRequest(atEndpoint: "subscribe")
    }

    private func sendUserRequest(atEndpoint endpoint: String) {
        guard let userName = usernameField.text, !userName.isEmpty else {
            showOkeyAlert(message: "Please enter username.")
            return
        }
        guard let url = URL(string: "http://localhost:5001/api/\(endpoint)/") else {
            showOkeyAlert(message: "Opps!! Bad url occured")
            return
        }
        showLoader()
        neworkLayer.postRequest(url: url, parameters: ["username": userName]) { [weak self] (result: Result<User, HTTPErrors>) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                self.client.setDelegate(self)
                self.client.login(withAuthToken: user.token)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.showOkeyAlert(message: error.localizedDescription)
                }
            }
        }
    }
}

extension LoginViewController: NXMClientDelegate {
    func client(_ client: NXMClient, didChange status: NXMConnectionStatus, reason: NXMConnectionStatusReason) {
        guard status == .connected else { return }
        navigationController?.pushViewController(TasksViewController(user: user), animated: true)
    }
    
    func client(_ client: NXMClient, didReceiveError error: Error) {
        print(error.localizedDescription)
    }

    func client(_ client: NXMClient, didReceive call: NXMCall) {
        NotificationCenter.default.post(name: .callReceived, object: call)
    }

    func client(_ client: NXMClient, didReceive conversation: NXMConversation) {
        NotificationCenter.default.post(name: .chatReceived, object: conversation)
    }
}

struct User: Decodable {
    let user: String
    let token: String
    var partner = ""
    
    enum CodingKeys: String, CodingKey {
        case user, token
    }
    
    static let none = User(user: "", token: "", partner: "")
}
