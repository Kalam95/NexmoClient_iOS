//
//  ViewController.swift
//  UniversalApp_swift
//
//  Created by Mehboob Alam on 28.04.22.
//

import UIKit

class ViewController: UIViewController {
    
    private let networkLayer = NetworkLayer()
    private var pageNumber = 0
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var apiSecretTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard //let url = URL(string: "https://api.nexmo.com/v2/applications"),
              let apiKey = apiKeyTextField.text,
              let apisecret = apiSecretTextField.text else {
            print("No data found")
            return
        }
    
        navigationController?.pushViewController(TasksViewController(), animated: true)
        AppManager.shared.apiSecret = apisecret
        AppManager.shared.apiKey = apiKey
        
//        networkLayer.getRequest(url: url) { (result: Result<AppList, HTTPErrors>) in
//            switch result {
//            case .success(let value):
//                DispatchQueue.main.async {
//                    if let vc = self.storyboard?.instantiateViewController(identifier: "AppListViewController") as? AppListViewController {
//                        vc.dataList = value._embedded?.applications
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
typealias AlertAction = (name: String, type: UIAlertAction.Style, callBack: ((UIAlertAction) -> Void)?)
extension UIViewController {
    func showAlert(title: String? = "Alert", message: String, actions: [AlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach {
            alert.addAction(UIAlertAction(title: $0.name, style: $0.type, handler: $0.callBack))
        }
        present(alert, animated: true, completion: nil)
    }

    func showOkeyAlert(title: String? = nil, message: String) {
        showAlert(title: title, message: message, actions: [("OK", .default, nil)])
    }
}
