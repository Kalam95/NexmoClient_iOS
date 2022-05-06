//
//  AppListViewController.swift
//  UniversalApp_swift
//
//  Created by Mehboob Alam on 28.04.22.
//

import UIKit

class AppListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataList: [Application]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "App List"
        tableView.register(DefaultTableviewCell.self, forCellReuseIdentifier: "Default")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createNewButtonTapped(_ sender: Any) {
        
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
