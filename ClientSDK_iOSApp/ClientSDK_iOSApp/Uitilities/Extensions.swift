//
//  Extensions.swift
//  UniversalApp_swift
//
//  Created by Mehboob Alam on 28.04.22.
//

import UIKit

typealias AlertAction = (name: String, type: UIAlertAction.Style, callBack: ((UIAlertAction) -> Void)?)
typealias InputAlertAction = (name: String, callBack: ((String?) -> Void)?)

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension UIView {
    @discardableResult
    func loadNib<T: UIView>(ofType type: T.Type) -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type), owner: self, options: nil)?.first as? T else {
            return nil
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return view
    }
}

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

    func showLoader() {
        let progressView = ProgressView(frame: view.frame)
        view.addSubview(progressView)
        progressView.activityIndicator.startAnimating()
    }

    func hideLoader() {
        if let progressView = view.subviews.first(where: {$0.isKind(of: ProgressView.self)}) {
            progressView.removeFromSuperview()
        }
    }
}
