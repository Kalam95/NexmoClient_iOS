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

typealias AlertAction = (name: String, type: UIAlertAction.Style, callBack: ((UIAlertAction) -> Void)?)
typealias InputAlertAction = (name: String, callBack: ((String?) -> Void)?)

extension UIViewController {
    func showAlert(title: String? = "Alert", message: String, actions: [AlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach {
            alert.addAction(UIAlertAction(title: $0.name, style: $0.type, handler: $0.callBack))
        }
        present(alert, animated: true, completion: nil)
    }

    func showOkeyAlert(title: String? = nil, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        showAlert(title: title, message: message, actions: [("OK", .default, handler)])
    }

    func showInputAlert(title: String? = nil, message: String?,
                        placeholder: String = "..", text: String? = nil,
                        handler: InputAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(.init(title: handler.name, style: .default, handler: {[unowned alert] _ in
            handler.callBack?(alert.textFields?.first?.text)
        }))
        alert.addTextField { field in
            field.placeholder = placeholder
            field.text = text
        }
        navigationController?.present(alert, animated: true, completion: nil)
    }
}
