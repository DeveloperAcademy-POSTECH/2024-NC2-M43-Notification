//
//  NotificationManager.swift
//  NC2-Notification
//
//  Created by 이윤학 on 6/17/24.
//

import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager: NSObject {
    static let instance = NotificationManager()
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    var notificationIdentifiers: [String] = []
    var badgeCount = 0
    var selectedAnswer: Int? = nil
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SUCCESS")
            }
        }
    }
    
    // UNTimeIntervalNotificationTrigger can be scheduled on the device to notify after the time interval, and optionally repeat.
    func timeTrigger(timeInterval: TimeInterval, isRepeated: Bool) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: isRepeated)
    }
    
    // UNLocationNotificationTrigger can be scheduled on the device to notify when the user enters or leaves a geographic region. The identifier on CLRegion must be unique. Scheduling multiple UNNotificationRequests with different regions containing the same identifier will result in undefined behavior. The number of UNLocationNotificationTriggers that may be scheduled by an application at any one time is limited by the system. Applications must have "when-in-use" authorization through CoreLocation. See the CoreLocation documentation for more information.
    func locationTrigger(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: CLLocationDistance, isRepeated: Bool, isEntry: Bool) -> UNNotificationTrigger {
        let coordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: 50.0)
        let region = CLCircularRegion(center: coordinate, radius: 100, identifier: UUID().uuidString)
        region.notifyOnExit = !isEntry
        region.notifyOnEntry = isEntry
        return UNLocationNotificationTrigger(region: region, repeats: isRepeated)
    }
    
    // UNCalendarNotificationTrigger can be scheduled on the device to notify based on date and time values, and optionally repeat. For example, if a notification should be delivered at the next 8:00 AM then set the 'hour' property of dateComponents to 8. If the notification should be delivered every day at 8:00 AM then set repeats to YES.
    func dateNotification(date: Date, isRepeated: Bool) -> UNNotificationTrigger {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: isRepeated)
    }
    
    func scheduleQuizNotification(quiz: Quiz, quizIndex: Int) {
        
        var actions: [UNNotificationAction] = []
        for index in 0..<quiz.options.count {
            let option = quiz.options[index]
            let action = UNNotificationAction(identifier: "\(index)",
                                              title: "\(index+1)) \(option)",
                                              options: .foreground)
            actions.append(action)
        }
        let categoryIdentifier = "QUIZ_CATEGORY"
        let quizAnswerCategory = UNNotificationCategory(identifier: categoryIdentifier,
                                                        actions: actions,
                                                        intentIdentifiers: [],
                                                        options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([quizAnswerCategory])
        
        badgeCount += 1
        let content = UNMutableNotificationContent()
        content.title = "알림을 꾸욱 눌러 문제를 풀어보세요."
        // content.title = "오늘의 문제가 도착했어요!"
        // content.subtitle = "알림을 꾸욱 눌러 문제를 풀어보세요."
        content.body = quiz.problem
        content.sound = .default
        content.badge = (badgeCount) as NSNumber
        content.categoryIdentifier = categoryIdentifier
        content.userInfo = ["quizIndex": quizIndex]
        
        let trigger = dateNotification(date: quiz.date, isRepeated: false)
        let request = UNNotificationRequest(identifier: quiz.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotificationRequst(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelNotificationRequest() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func removeNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        badgeCount = 0
        UNUserNotificationCenter.current().setBadgeCount(badgeCount, withCompletionHandler: nil)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let quizIndex = response.notification.request.content.userInfo["quizIndex"] as? Int
        
        switch response.actionIdentifier {
        case "0":
            selectedAnswer = 0
        case "1":
            selectedAnswer = 1
        case "2":
            selectedAnswer = 2
        default:
            selectedAnswer = nil
        }
        
        removeNotification()
        NavigationManager.shared.pushNotificatinoResult(selectedAnswer: selectedAnswer,
                                                        quizIndex: quizIndex)
        completionHandler()
    }
}
