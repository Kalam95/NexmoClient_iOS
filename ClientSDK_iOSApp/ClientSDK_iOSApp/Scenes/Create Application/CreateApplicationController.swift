//
//  CreateApplicationController.swift
//  UniversalApp_swift
//
//  Created by Mehboob Alam on 28.04.22.
//

import UIKit

class CreateApplicationController: UIViewController {

    @IBOutlet weak var nameTextView: UITextField!
    private var networklayer = NetworkLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        createApp()
        // Do any additional setup after loading the view.
    }

    func createApp() {
        guard let url = URL(string: "https://api.nexmo.com/v2/applications"),
              let name = nameTextView.text, !name.isEmpty else {
            return
        }
        networklayer.postRequest(url: url, parameters: ["name": name]) { (result: Result<Application, HTTPErrors>) in
            print(result)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
