//
//  ViewController.swift
//  Project21
//
//  Created by Glenn R. Fisher on 8/14/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Register",
            style: .plain,
            target: self,
            action: #selector(registerLocal)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Schedule",
            style: .plain,
            target: self,
            action: #selector(scheduleLocal)
        )
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            granted ? print("Yay!") : print("D'oh")
        }
    }
    
    func scheduleLocal() {
        
        // ensure alarm category is registered
        registerCategories()
        
        // define notification content
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird gets the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        // define a calendar notification trigger
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let calendarTrigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        
        // define an internal notification trigger
        let intervalTrigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )
        
        // define a notification request
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: intervalTrigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func registerCategories() {
        
        let show = UNNotificationAction(
            identifier: "show",
            title: "Tell me more...",
            options: .foreground
        )
        let category = UNNotificationCategory(
            identifier: "alarm",
            actions: [show],
            intentIdentifiers: []
        )
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.setNotificationCategories([category])
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        
        guard let customData = userInfo["customData"] else {
            completionHandler()
            return
        }
        
        print("Custom data received: \(customData)")
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier: print("Default identifier")
        case "show": print("Show more information...")
        default: break
        }
        
        completionHandler()
    }
}

