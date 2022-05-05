//
//  CallViewController.swift
//  TestClientSDk
//
//  Created by Mehboob Alam on 25.04.22.
//

import UIKit
import NexmoClient

class CallViewController: UIViewController {
    
    let user: User
    let client = NXMClient.shared
    let nc = NotificationCenter.default
    
    var call: NXMCall?
    
    init(user: User) {
        self.user = user
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nc.addObserver(self, selector: #selector(didReceiveCall), name: .call, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func callFunc(_ sender: Any) {
        print("Calling \(user.callPartnerName)")
//        client.serverCall(withCallee: "Alice", customData: nil) { error, call in
//            if error != nil {
//                print(error?.localizedDescription)
//                return
//            }
//            call?.setDelegate(self)
//            self.call = call
//        }
        client.serverCall(withCallee: user.callPartnerName, customData: nil) { error, call in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            call?.setDelegate(self)
            self.call = call
        }
    }
    
    @IBAction func hangupFunc(_ sender: Any) {
        endCall()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @objc private func didReceiveCall(_ notification: Notification) {
        guard let call = notification.object as? NXMCall else { return }
        DispatchQueue.main.async { [weak self] in
            self?.displayIncomingCallAlert(call: call)
        }
    }
    
    private func displayIncomingCallAlert(call: NXMCall) {
        let from = call.myMember?.channel?.from.data ?? "Unknown"
        
        let alert = UIAlertController(title: "Incoming call from", message: from, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Answer", style: .default, handler: { _ in
            call.answer { error in
                if error != nil {
                    print(error)
                    return
                }
                call.setDelegate(self)
                self.call = call
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
            call.reject(nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func endCall() {
        call?.hangup()
        client.logout()
        navigationController?.popViewController(animated: true)
    }
    
}

extension CallViewController: NXMCallDelegate {
    func call(_ call: NXMCall, didUpdate callMember: NXMMember, with status: NXMCallMemberStatus) {
        switch status {
        case .answered:
            guard callMember.user.name != self.user.name else { return }
            print("answered")
        case .completed:
            self.call = nil
        default:
            break
        }
    }
    
    func call(_ call: NXMCall, didReceive error: Error) {
        print(error.localizedDescription)
    }
    
    func call(_ call: NXMCall, didUpdate callMember: NXMMember, isMuted muted: Bool) {
        
    }
    
    
    func client(_ client: NXMClient, didReceive conversation: NXMConversation) {
        
    }
    
    func call(_ call: NXMCall, didReceive dtmf: String, from member: NXMMember?) {
        
    }
}

extension ViewController {
    func client(_ client: NXMClient, didReceive call: NXMCall) {
        NotificationCenter.default.post(name: .call, object: call)
    }
}
