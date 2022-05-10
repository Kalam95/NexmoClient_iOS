//
//  TasksViewController.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 01.05.22.
//

import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let tasks = Tasks.allCases
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("not Implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DefaultTableviewCell.self, forCellReuseIdentifier: "Default")
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

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].rawValue
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        switch task {
        case .inAppChat:
            navigationController?.pushViewController(ChatListViewController(user: user),
                                                     animated: true)
        case .inAppCall, .phoneCall, .receivePhoneCall:
            navigationController?.pushViewController(AppToAppCallViewController(user: user, task: task),
                                                     animated: true)
        }
    }
}

enum Tasks: CaseIterable {
    case inAppCall, phoneCall, receivePhoneCall, inAppChat
    
    var rawValue: String {
        switch self {
        case .inAppCall:
            return "App to App Call"
        case .phoneCall:
            return "App to Phone Call"
        case .receivePhoneCall:
            return "Phone to App Call"
        case .inAppChat:
            return "In App Chat"
        }
    }
}

class DefaultTableviewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
}
