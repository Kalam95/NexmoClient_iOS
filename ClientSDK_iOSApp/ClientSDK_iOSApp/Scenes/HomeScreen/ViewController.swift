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
        navigationItem.rightBarButtonItem = .init(title: "Apps", style: .plain, target: self, action: #selector(showApps))
        // Do any additional setup after loading the view.
    }

    @objc private func showApps() {
        guard let key = apiKeyTextField.text, !key.isEmpty,
              let sec = apiSecretTextField.text, !sec.isEmpty else {
            showOkeyAlert(title: "Alert", message: "Please API key and Secret to proceed")
            return
        }
        AppManager.shared.apiSecret = sec
        AppManager.shared.apiKey = key
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AppListViewController") else {
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(TasksViewController(), animated: true)
    }
}
