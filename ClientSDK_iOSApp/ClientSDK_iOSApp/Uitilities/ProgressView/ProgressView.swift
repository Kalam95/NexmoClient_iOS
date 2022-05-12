//
//  ProgressView.swift
//  ClientSDK_iOSApp
//
//  Created by Mehboob Alam on 10.05.22.
//

import UIKit

class ProgressView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib(ofType: Self.self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib(ofType: Self.self)
    }
}
