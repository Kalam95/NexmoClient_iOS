//
//  AppDelegate.swift
//  TestClientSDk
//
//  Created by Mehboob Alam on 25.04.22.
//

import UIKit
import NexmoClient

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        URLSession.shared.dataTask(with: URL(string: "http://localhost:5002/close")!) { data, response, error in
            print(data)
        }.resume()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    let JWT = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2NTA4ODI4NDEsImV4cCI6MTY1MDkwNDQ0MSwianRpIjoiYTZJQzFDVkRUaHNxIiwiYXBwbGljYXRpb25faWQiOiJkYjQ1ZTdjNy0zYzcwLTQ2NzktOTE0ZC0yZGY2NmRkYjBhN2MifQ.aoMqp1yqle4QAcF65Q6GRz1mUAl9FIcLmgkABOzEswaalLVbb5LhfTe4aHIInMDZOt9r-oApBbt6U5MuVUwlFKP3yml_oZozNOnNqncNvXO9p-ef9KE0PwfTGiuL5l8lLu9wudJdEq_G6GH_lyKX6o7YDouKoL9-0iAtB97hEKq-sSQ6ziwhQJ2mAtvwqFW7ohcsuUciYTCNShWbmdlMGHdeolB_O8pBjfKLzj15dmBmzFqGSOdJIvlUT6LZoqGc3gyonJjaDB3PzlvsleM5s_7L8Lxq7eSz1E6MI41v5qyVfrYErxNVqo78txJ1dOfP1OaQ25n2TWoK-nWZP7xbHA"
}
