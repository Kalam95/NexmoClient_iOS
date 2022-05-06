//
//  AppListViewController.swift
//  UniversalApp_swift
//
//  Created by Mehboob Alam on 28.04.22.
//

import UIKit

class AppListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var dataList: [Application]?
    private var networklayer = NetworkLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "App List"
        tableView.register(DefaultTableviewCell.self, forCellReuseIdentifier: "Default")
        getApps()
        navigationItem.rightBarButtonItem = .init(title: " + ", style: .plain, target: self, action: #selector(createNewButtonTapped))
    }

    private func getApps() {
        guard let url = URL(string: "https://api.nexmo.com/v2/applications") else { return }
        networklayer.getRequest(url: url) { [weak self] (result: Result<AppList, HTTPErrors>) in
            switch result {
            case .success(let value):
                self?.dataList = value._embedded?.applications
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showOkeyAlert(title: "Error!", message: error.localizedDescription)
                }
            }
        }
    }

    @objc private func createNewButtonTapped() {
        showInputAlert(title: "Creat App", message: "Enter a name for the app, to be created.", handler: ("Create", {[weak self] name in
            guard let name = name, name.isEmpty else {
                self?.showOkeyAlert(message: "Please!!! Enter a valid name of the app.")
                return
            }
            guard let url = URL(string: "https://api.nexmo.com/v2/applications") else { return }
            self?.networklayer.postRequest(url: url, parameters: ["name": name]) { (result: Result<Application, HTTPErrors>) in
                let message: String
                switch result {
                case .success(let value):
                    print(value.keys ?? "")
                    message = "Application created Successfully"
                    self?.getApps()
                case .failure(let error):
                    message = error.localizedDescription
                }
                DispatchQueue.main.async {
                    self?.showOkeyAlert(message: message)
                }
            }
        }))
    }
}

extension AppListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
        cell.textLabel?.text = dataList?[indexPath.row].name ?? "N/A"
        cell.detailTextLabel?.text = dataList?[indexPath.row].id ?? "N/A"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataList?[indexPath.row] else {
            return
        }
        AppManager.shared.selectedApplication =  data
    }
}
