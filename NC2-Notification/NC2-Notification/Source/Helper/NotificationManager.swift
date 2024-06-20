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
    
    func makeNotificationDateTrigger(date: Date, isRepeated: Bool) -> UNNotificationTrigger {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: isRepeated)
    }
    
    func makeNotificationContent(quiz: Quiz, quizIndex: Int) -> UNMutableNotificationContent {
        badgeCount += 1
        
        let content = UNMutableNotificationContent()
        content.title = "알림을 꾸욱 눌러 문제를 풀어보세요."
        content.body = "Q. \(quiz.problem)"
        content.sound = .default
        content.badge = (badgeCount) as NSNumber
        content.userInfo = ["quizIndex": quizIndex]
        return content
    }
    
    func addActionButton(quiz: Quiz, categoryIdentifier: String) {
        var actions: [UNNotificationAction] = []
        for index in 0..<quiz.options.count {
            let option = quiz.options[index]
            let action = UNNotificationAction(identifier: "\(index)",
                                              title: "\(index+1)) \(option)",
                                              options: .foreground)
            actions.append(action)
        }
        let categoryIdentifier = categoryIdentifier
        let quizAnswerCategory = UNNotificationCategory(identifier: categoryIdentifier,
                                                        actions: actions,
                                                        intentIdentifiers: [],
                                                        options: .allowInCarPlay)
        
        UNUserNotificationCenter.current().setNotificationCategories([quizAnswerCategory])
    }
    
    func scheduleQuizNotification(quiz: Quiz, quizIndex: Int) {
        var content = makeNotificationContent(quiz: quiz, quizIndex: quizIndex)
        
        let categoryIdentifier = "QUIZ_CATEGORY"
        content.categoryIdentifier = categoryIdentifier
        addActionButton(quiz: quiz, categoryIdentifier: categoryIdentifier)
        
        let trigger = makeNotificationDateTrigger(date: quiz.date, isRepeated: false)
        
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
