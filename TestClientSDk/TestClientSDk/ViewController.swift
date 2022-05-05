//
//  ViewController.swift
//  TestClientSDk
//
//  Created by Mehboob Alam on 25.04.22.
//

import Foundation
import UIKit
import AVFoundation
import NexmoClient

class ViewController: UIViewController {
//    lazy var object = NXMCall()

    let client = NXMClient.shared

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askAudioPermissions()
        client.setDelegate(self)
        // Do any additional setup after loading the view.
    }

    @IBAction func call(_ sender: Any) {
//        object.answer {  error in
//            print(error)
//        }
    }

    func askAudioPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted:Bool) in
            print("Allow microphone use. Response: %d", granted)
        }
    }

    @IBAction func aliseLogin(_ sender: Any) {
        user = .Alice
        client.setDelegate(self)
        client.login(withAuthToken: user!.jwt)
    }
    
    @IBAction func bobLogin(_ sender: Any) {
        user = .Bob
        client.setDelegate(self)
        client.login(withAuthToken: user!.jwt)
    }
    
}

extension ViewController: NXMClientDelegate {
    func client(_ client: NXMClient, didChange status: NXMConnectionStatus, reason: NXMConnectionStatusReason) {
        print(#function, status, reason)
        if status == .connected {
            navigationController?.pushViewController(CallViewController(user: user!), animated: true)
        }
    }
    
    func client(_ client: NXMClient, didReceiveError error: Error) {
        print(#function, client, error)
    }
    
    
}


struct User {
    let name: String
    let jwt: String
    let callPartnerName: String
}

extension User {
    static let Alice = User(name: "Alice",
                            jwt:"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTEwNjEyNDksImp0aSI6IjljNWIwMDQwLWM2MjItMTFlYy1iYmNjLTliYjdlZGZkMzdjOSIsImFwcGxpY2F0aW9uX2lkIjoiY2U5MDNlOTMtYTI5OC00ZWUyLThhNGEtODE4ZWY1ODJmMWNiIiwic3ViIjoiQWxpY2UiLCJleHAiOjE2NTEwNjEyNzEyMDMsImFjbCI6eyJwYXRocyI6eyIvKi91c2Vycy8qKiI6e30sIi8qL2NvbnZlcnNhdGlvbnMvKioiOnt9LCIvKi9zZXNzaW9ucy8qKiI6e30sIi8qL2RldmljZXMvKioiOnt9LCIvKi9pbWFnZS8qKiI6e30sIi8qL21lZGlhLyoqIjp7fSwiLyovYXBwbGljYXRpb25zLyoqIjp7fSwiLyovcHVzaC8qKiI6e30sIi8qL2tub2NraW5nLyoqIjp7fSwiLyovbGVncy8qKiI6e319fX0.Imd4V6O_Z4tkQxysG6RdJmlB-stTPhMizuuh3ymuTnKKO4TuZx-mhQ6DeBXN4I_1G4pT-z2fVB3rSjdHR0YJHBog6-mO_bD1Nt1WowUWNKfYoh1M4F1hShc1Zgm2ZO_RNUigCSPsnHsQGkwPox6idf8xglD7gpJfLm86ghtfVCThZg5qks5fDkgptYhV2pIWSDHswKXcyukVJyWBt7oKKQUK03XR6tWF4FIwMww47BoqyvT6kGTVP7WPS5R0U0Vy14ai05ZmliMpzo-SF90g3hjL5zAfHe8Kj-z8g9eaHSUoKXMXir8t21ZpxEgNL2H15CBeouI1cWXnPmo8EOBrEw",
                            callPartnerName: "919953421262")
    static let Bob = User(name: "Bob",
                          jwt:"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTEwNjIzMjUsImp0aSI6IjFkY2NiZjkwLWM2MjUtMTFlYy1hOTBiLTQ3YTk0MTQwNGI1ZCIsImFwcGxpY2F0aW9uX2lkIjoiY2U5MDNlOTMtYTI5OC00ZWUyLThhNGEtODE4ZWY1ODJmMWNiIiwic3ViIjoiQm9iIiwiZXhwIjoxNjUxMDYyMzQ3MzY5LCJhY2wiOnsicGF0aHMiOnsiLyovdXNlcnMvKioiOnt9LCIvKi9jb252ZXJzYXRpb25zLyoqIjp7fSwiLyovc2Vzc2lvbnMvKioiOnt9LCIvKi9kZXZpY2VzLyoqIjp7fSwiLyovaW1hZ2UvKioiOnt9LCIvKi9tZWRpYS8qKiI6e30sIi8qL2FwcGxpY2F0aW9ucy8qKiI6e30sIi8qL3B1c2gvKioiOnt9LCIvKi9rbm9ja2luZy8qKiI6e30sIi8qL2xlZ3MvKioiOnt9fX19.fhPizCOYY3TfrsfGKG-_NgFtrYqeUKW9N6iZx9W2VUKNTUoDTZN0RaGaOGM6xWfKTlSg-b3AWZ2OkU7iNQl65PtBiYD9j0GNxElXFlwDqT9QWgL9N2OrY3kUcVyuXQRy1c-lSl7LEfdXCiAWSXF37NQm9_WM67oyfls6FCGloMZ59HlYjlfqjJ7PN6Upqy9VCz00gRneGP77-ZUvjqew9WxxZUe5_Wk-MqHto08jwL5xmfL21Ay6oO4wywHww5_gTDhoGGHjl44rWCIjQhRS0WUweUxAhS4ZSC89y50f9glKWH2u2fbLHQVUrP7hG_ZmhpfmcIWBjr7lTJOk1TTZDw",
                          callPartnerName: "919910002015")
}

// USR-8479ac04-ed2e-490f-a93f-90cd2cb940f7 Elisa
// USR-4aba8eb4-e2bd-42a9-99b6-d197f5e15634 Alam



extension Notification.Name {
    static var call: Notification.Name {
        return .init(rawValue: "NXMClient.incomingCall")
    }
}
