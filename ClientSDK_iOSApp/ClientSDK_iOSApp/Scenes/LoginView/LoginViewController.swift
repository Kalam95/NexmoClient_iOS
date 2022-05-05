//
//  LoginViewController.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 01.05.22.
//

import UIKit
import NexmoClient

class LoginViewController: UIViewController {

    @IBOutlet weak var partnerField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var jwtView: UITextView!

    let client = NXMClient.shared
    let neworkLayer: NetworkLayer = .init()
    private var user: User!
    let task: Tasks

    init(task: Tasks) {
        self.task = task
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        jwtView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.8).cgColor
        jwtView.layer.cornerRadius = 5
        jwtView.layer.borderWidth = 1
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        client.logout()
    }

    @IBAction func loginButtonTapped() {
        guard let userName = usernameField.text, let jwt = jwtView.text,
                !userName.isEmpty, !jwt.isEmpty else { return }
        client.setDelegate(self)
        self.user = .init(jwt: jwt, name: userName, partner: partnerField.text ?? "")
        client.login(withAuthToken: jwt)
    }

    @IBAction func alam2(_ sender: Any) {
        self.user = .alam2
        client.setDelegate(self)
        client.login(withAuthToken: User.alam2.jwt)
    }

    @IBAction func newAlam(_ sender: Any) {
        self.user = .newAlam
        client.setDelegate(self)
        client.login(withAuthToken: User.newAlam.jwt)
    }
}

extension LoginViewController: NXMClientDelegate {
    func client(_ client: NXMClient, didChange status: NXMConnectionStatus, reason: NXMConnectionStatusReason) {
        guard status == .connected else { return }
        pushToNextScreen()
    }
    
    func client(_ client: NXMClient, didReceiveError error: Error) {
        print(error.localizedDescription)
    }

    func client(_ client: NXMClient, didReceive call: NXMCall) {
        NotificationCenter.default.post(name: .callReceived, object: call)
    }

    func pushToNextScreen() {
        switch task {
        case .inAppChat:
            navigationController?.pushViewController(ChatListViewController(user: user),
                                                     animated: true)
        case .inAppCall, .phoneCall, .receivePhoneCall:
            navigationController?.pushViewController(AppToAppCallViewController(user: user, task: task),
                                                     animated: true)
        }
    }

    func client(_ client: NXMClient, didReceive conversation: NXMConversation) {
        NotificationCenter.default.post(name: .chatReceived, object: conversation)
    }
}

struct User {
    var jwt: String
    var name: String
    var partner: String
    var memberID: String = ""
    static var newAlam: Self = .init(jwt: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTE1OTI3NjUsImp0aSI6IjI0NmZmNTYwLWNhZjgtMTFlYy04MjE1LTk1ZjM5MGRjYjEyOSIsImFwcGxpY2F0aW9uX2lkIjoiNGZlZDNkN2EtM2Y2NS00MzZkLTg3ZGQtNzc1MTM5NGFhNDMzIiwic3ViIjoibmV3QWxhbSIsImV4cCI6MTY1MTU5Mjc4Njk2NiwiYWNsIjp7InBhdGhzIjp7Ii8qL3VzZXJzLyoqIjp7fSwiLyovY29udmVyc2F0aW9ucy8qKiI6e30sIi8qL3Nlc3Npb25zLyoqIjp7fSwiLyovZGV2aWNlcy8qKiI6e30sIi8qL2ltYWdlLyoqIjp7fSwiLyovbWVkaWEvKioiOnt9LCIvKi9hcHBsaWNhdGlvbnMvKioiOnt9LCIvKi9wdXNoLyoqIjp7fSwiLyova25vY2tpbmcvKioiOnt9LCIvKi9sZWdzLyoqIjp7fX19fQ.PuIixm_PBimadCsdMSx2YPtKtrJ6ouWY7hNC3viapmhj64sqv2LXZptStyQFVvr83Yi2ggl1FuTK4FPESC1ZqrIWBTKxEgwUWzNOn2l1DBVHXTpnKIYcZGylRTiRd--CruQBte2qnxEp1L3D6ZMszaYHeRUMp-HBb5YcmXXHrvFXJPVwOEZo_LqJhq4nNBfx-IAQB2dk1Lxs4ZEMDK5BwCOMBTYCEa9uoQ1i3Qkw-ZVDr_As-SEy74euj_Mpq2dAi1KdV4H3vRzlJAYWnXOr7YMaYg75DIWPI5bucE3fEnsJTslPiCSLZg5REej7LOzKUa3MlwP6f3TPMBxgpZFLWg", name: "newAlam", partner: "Alam2")
    
    static let alam2 = User(jwt: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTE1OTI3MDksImp0aSI6IjAzNjhlOTMwLWNhZjgtMTFlYy1hYjFjLTRmNTJlOWJjMjBkNiIsImFwcGxpY2F0aW9uX2lkIjoiNGZlZDNkN2EtM2Y2NS00MzZkLTg3ZGQtNzc1MTM5NGFhNDMzIiwic3ViIjoiQWxhbTIiLCJleHAiOjE2NTE1OTI3MzE1NTQsImFjbCI6eyJwYXRocyI6eyIvKi91c2Vycy8qKiI6e30sIi8qL2NvbnZlcnNhdGlvbnMvKioiOnt9LCIvKi9zZXNzaW9ucy8qKiI6e30sIi8qL2RldmljZXMvKioiOnt9LCIvKi9pbWFnZS8qKiI6e30sIi8qL21lZGlhLyoqIjp7fSwiLyovYXBwbGljYXRpb25zLyoqIjp7fSwiLyovcHVzaC8qKiI6e30sIi8qL2tub2NraW5nLyoqIjp7fSwiLyovbGVncy8qKiI6e319fX0.KA6BtxhW8cdESxscCIyRw7A9T9UtuclcpWb5o_HHm4FlRyy9S077-5rQiQBmcwiOwtuDEv5hymDfEozNCZ8rsTf6zSjlcYo10g37Fo3_r4VBPWwdMLmjiYpuJbHCF1qT4vTNMMekVKAwlk6HWQ00zfkxdUy_sV2-Gnv7joq3-YFF-ZMbkEz1NL5oVJRIKKVnaImBr0TKKanVQFM-AK81KqINdSDTa2TGRtXHMbaLqd_obOB-fm4D9wxNw2FIlaV2BIDCgaDv1V9uOJFMCbPnr5e9oK8X7TEhABY45Ou78SslLruhidP5Ujg4_luaXXXlid952uEnE2IiUuLHT2dLQA", name: "Alam2", partner: "newAlam")
}
