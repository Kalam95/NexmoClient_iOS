//
//  ChatViewController.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 01.05.22.
//

import UIKit
import NexmoClient

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextView!
    
    private var data: [NXMEvent] = [] {
        willSet {
            newValue.forEach { element in
                let key = element.creationDate.formatted(date: .abbreviated, time: .omitted)
                self.dataScource[key] = (self.dataScource[key] ?? []) + [element]
            }
        }
    }
    private let client = NXMClient.shared
    private let user: User
    private var conversation: NXMConversation
    private var dataScource: [String: [NXMEvent]] = [:] {
        willSet {
            keys = newValue.keys.reversed()
        }
    }
    private var keys: [String] = []
    
    init(user: User, conversation: NXMConversation) {
        self.user = user
        self.conversation = conversation
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.layer.borderColor = UIColor.cyan.cgColor
        messageTextField.layer.borderWidth = 1
        messageTextField.layer.cornerRadius = 5
        conversation.delegate = self
        conversation.join()
        tableView.register(UINib(nibName: "ChatViewCell", bundle: nil),
                           forCellReuseIdentifier: "ChatViewCell")
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { [weak self] notification in
            if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size {
                self?.view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height - 20, right: 0)
                self?.bottomConstraint.constant = kbSize.height - 20
                    }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.bottomConstraint.constant = 0
        }
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Invite", style: .plain,
                                                              target: self, action: #selector(invite)),
                                              UIBarButtonItem(title: "Members", style: .plain,
                                                              target: self, action: #selector(navigateToMembers))]
        conversation.getEventsPage(withSize: 100, order: .asc) { [weak self] error, events in
            DispatchQueue.main.async {
                guard let events = events else {
                    self?.showOkeyAlert(message: error?.localizedDescription ?? "Opps!!! Something went wrong")
                    return
                }
                self?.data = events.events.compactMap { $0 as? NXMMessageEvent }
                self?.tableView.reloadData()
            }
        }
    }
    

    @objc func navigateToMembers() {
        // Members
    }

    @IBAction func sendButtonTapped(_ sender: Any) {
        messageTextField.resignFirstResponder()
        let text = messageTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messageTextField.isUserInteractionEnabled = false
        conversation.sendMessage(NXMMessage(text: text), completionHandler: { [unowned self] error in
            DispatchQueue.main.async {
                self.messageTextField.isUserInteractionEnabled = true
                self.messageTextField.text = ""
            }
        })
    }

    @objc func invite() {
        conversation.inviteMember(withUsername: user.partner) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showOkeyAlert(message: String(describing: error))
                }
                self?.conversation.joinMember(withUsername: self?.user.partner ?? "")
                return
            }
        }
    }
}

extension ChatViewController: NXMConversationDelegate {
    func conversation(_ conversation: NXMConversation, didReceive error: Error) {
        print("conversation Failed", error.localizedDescription)
    }

    func conversation(_ conversation: NXMConversation, didReceive event: NXMTextEvent) {
        guard event.text?.isEmpty == false else { return }
        self.data.append(event)
        tableView.reloadData()
    }

    func conversation(_ conversation: NXMConversation, didReceive event: NXMMessageEvent) {
        self.data.append(event)
        tableView.reloadData()
    }

    func conversation(_ conversation: NXMConversation, didReceive event: NXMMemberEvent) {

    }
    
    func conversation(_ conversation: NXMConversation, didReceive event: NXMLegTransferEvent, newConversation: NXMConversation) {
    }

    func conversation(_ conversation: NXMConversation, onMediaConnectionStateChange state: NXMMediaConnectionStatus, legId: String) {
        print("test")
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataScource[keys[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatViewCell", for: indexPath) as? ChatViewCell
        let data = dataScource[keys[indexPath.section]]?[indexPath.row] as? NXMMessageEvent
        let isSender = data?.embeddedInfo?.user.name == user.name
        cell?.setAlignment(isSender)
        cell?.messageLabel.text = data?.text ?? "N/A"
        let name = isSender ? "You" : data?.embeddedInfo?.user.name
        cell?.senderLabel.text = "By: \(name ?? "N/A")"
        cell?.dateLabel.text = data?.creationDate.formatted(date: .omitted, time: .shortened)
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.text = keys[section]
        label.sizeToFit()
        return label
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
