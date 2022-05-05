//
//  ApplicationModel.swift
//  UniversalApp_swift
//
//  Created by Mehboob Alam on 28.04.22.
//

import Foundation

struct AppList: Decodable {
    var page_size: Int?
    var page: Int?
    var total_items: Int?
    var total_pages: Int?
    var _embedded: Embedded?
}

struct Embedded: Decodable {
    var applications: [Application]?
}

struct Application: Decodable {
    var id: String?
    var name: String?
    var capabilities: Capabilities?
}

struct Capabilities: Decodable {
    var voice: Webhooks?
    var messages: Webhooks?
    var rtc: Webhooks?
}

struct Webhooks: Decodable {
    var inbound_url: WebhookURL?
    var status_url: WebhookURL?
    var event_url: WebhookURL?
    var answer_url: WebhookURL?
    var fallback_answer_url: WebhookURL?
}

struct WebhookURL: Decodable {
    var address: String
    var http_method: String
    var connection_timeout: Double?
    var socket_timeout: Double?
}

class AppManager {
    static let shared = AppManager()
    var selectedApplication: Application?
    var apiKey = ""
    var apiSecret = ""
    var basicHeaders: [String: String] {
        return ["Authorization": "Basic \("\(apiKey):\(apiSecret)".toBase64())",
                "Content-type":"application/json"]
    }

    private init() {
        
    }
}
