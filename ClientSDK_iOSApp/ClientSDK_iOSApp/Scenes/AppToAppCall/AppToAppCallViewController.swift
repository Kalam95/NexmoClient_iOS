//
//  AppToAppCallViewController.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 01.05.22.
//

import UIKit
import NexmoClient

class AppToAppCallViewController: UIViewController {

    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    private let user: User
    private let client = NXMClient.shared
    private let nc = NotificationCenter.default
    private var call: NXMCall?

    init(user: User) {
        self.user = user
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.user = .none
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.user
        callButton.backgroundColor = .green
        nc.addObserver(self, selector: #selector(didReceiveCall), name: .callReceived, object: nil)
        // Do any additional setup after loading the view.
    }

    @objc private func didReceiveCall(_ notification: Notification) {
        guard let call = notification.object as? NXMCall else { return }
        DispatchQueue.main.async { [weak self] in
            self?.displayIncomingCallAlert(call: call)
        }
    }

    @IBAction func callButtonTapped(_ sender: Any) {
        if call != nil {
            endCall()
            return
        }
        guard let callee = phoneNumberField.text, !callee.isEmpty else {
            showOkeyAlert(title: "Invalid user", message: "Please enter a valid username/phonenumber to call")
            return
        }
        phoneNumberCall(name: callee)
    }

    private func phoneNumberCall(name: String) {
        client.serverCall(withCallee: name, customData: nil) { [weak self] error, call in
            guard let self = self else { return }
            self.call = call
            self.call?.setDelegate(self)
            self.updateButton(isActive: call == nil)
        }
    }

    private func updateButton(isActive: Bool) {
        DispatchQueue.main.async {
            self.callButton.backgroundColor = isActive ? .green : .red
            self.callButton.setTitle(isActive ? "Call" : "handUP", for: .normal)
        }
    }

    private func displayIncomingCallAlert(call: NXMCall) {
        let from = call.myMember?.channel?.from.data ?? "Unknown"
        let alert = UIAlertController(title: "Incoming call from", message: from, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Answer", style: .default, handler: { _ in
            call.answer { error in
                if error != nil {
                    print(error ?? "No Error")
                    return
                }
                self.call = call
                self.updateButton(isActive: false)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { [weak self] _ in
            call.reject()
            self?.updateButton(isActive: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func endCall() {
        call?.hangup()
        call = nil
        callButton.setTitle("Call", for: .normal)
        callButton.backgroundColor = .green
    }
}

extension AppToAppCallViewController: NXMCallDelegate {
    func call(_ call: NXMCall, didUpdate member: NXMMember, isMuted muted: Bool) {
        print("updated")
    }
    
    func call(_ call: NXMCall, didReceive error: Error) {
        print("Call did not connect")
    }
    
    func call(_ call: NXMCall, didUpdate callMember: NXMMember, with status: NXMCallMemberStatus) {
        switch status {
        case .answered:
            guard callMember.user.name != self.user.user else { return }
            callButton.backgroundColor = .red
            callButton.setTitle("Hangup", for: .normal)
        case .rejected, .cancelled, .busy:
            callButton.backgroundColor = .green
            callButton.setTitle("Call", for: .normal)
        case .completed:
            self.call = nil
        default:
            break
        }
    }

    func call(_ call: NXMCall, didReceive dtmf: String, from member: NXMMember?) {
        nc.post(name: .callReceived, object: call)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension AppToAppCallViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension  Notification.Name {
    static let callReceived: Self = .init(rawValue: "Call received")
    static let chatReceived: Self = .init(rawValue: "chat received")
    static let chatSent: Self = .init(rawValue: "chat sent")
}

