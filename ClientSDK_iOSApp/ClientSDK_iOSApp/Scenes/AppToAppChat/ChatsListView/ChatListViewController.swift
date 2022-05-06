//
//  ChatListViewController.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 03.05.22.
//

import UIKit
import NexmoClient

class ChatListViewController: UIViewController {

    private var data: [NXMEvent] = []
    private let client = NXMClient.shared
    private let user: User
    
    private var conversationPage: NXMConversationsPage?
    
    @IBOutlet weak var tableView: UITableView!

    init(user: User) {
        self.user = user
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
        tableView.register(DefaultTableviewCell.self, forCellReuseIdentifier: "Default")
        client.getConversationsPage(withSize: 10, order: .asc, filter: nil) { [weak self] error, page in
            self?.conversationPage = page
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: " + ", style: .plain, target: self, action: #selector(addNewConversation))
    }

    @objc func addNewConversation() {
        client.createConversation(withName: "ConversationInAppChat") { [unowned self] error, conversation in
            DispatchQueue.main.async {
                guard let conversation = conversation else {
                    self.showOkeyAlert(message: error.debugDescription)
                    return
                }
                self.navigationController?.pushViewController(ChatViewController(user: self.user, conversation: conversation), animated: true)
                
            }
        }
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationPage?.conversations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        let data = conversationPage?.conversations[indexPath.row]
        cell.textLabel?.text = data?.displayName ?? data?.name
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversation = conversationPage?.conversations[indexPath.row] else { return }
        self.navigationController?.pushViewController(ChatViewController(user: self.user,
                                                                         conversation: conversation), animated: true)
    }
}
