//
//  MemberViewController.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 06.05.22.
//

import UIKit
import NexmoClient

class MemberViewController: UIViewController {

    private let conversation: NXMConversation
    private let user: User
    private var members: [NXMMemberSummary] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    init(conversation: NXMConversation, user: User) {
        self.conversation = conversation
        self.user = user
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented this way")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DefaultTableviewCell.self, forCellReuseIdentifier: "Default")
        title = conversation.displayName ?? conversation.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: .plain,
                                                              target: self, action: #selector(invite))
        conversation.getMembersPage(withPageSize: 100, order: .asc) { [weak self] error, page in
            self?.members = page?.memberSummaries.filter { $0.state != .joined } ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc func invite() {
        showInputAlert(title: "Add Member", message: "Please enter the username to be added.", text: user.partner, handler: ("Add", { [unowned self] name in
            guard let name = name else {
                self.showOkeyAlert(title: "Alert!", message: "Please enter a valid name")
                return
            }
            self.add(member: name)
        }))
    }

    func add(member: String) {
        conversation.inviteMember(withUsername: member) { [weak self] error in
            self?.conversation.joinMember(withUsername: member)
            DispatchQueue.main.async {
                guard let error = error else {
                    self?.showOkeyAlert(message: "User added successfully")
                    return
                }
                self?.showOkeyAlert(title: "Alert", message: error.localizedDescription)
            }
        }
    }

    func kickoutMember(id: String) {
        conversation.kickMember(withMemberId: id) { [weak self] error in
            DispatchQueue.main.async {
                guard let error = error else {
                    self?.showOkeyAlert(message: "User deleted successfully")
                    return
                }
                self?.showOkeyAlert(title: "Alert", message: error.localizedDescription)
            }
        }
    }
}

extension MemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
        cell.accessoryType = .none
        let member =  members[indexPath.row].user
        cell.textLabel?.text = member.name
        return cell
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "Remove"
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        kickoutMember(id: members[indexPath.row].memberUuid)
    }
    
}
