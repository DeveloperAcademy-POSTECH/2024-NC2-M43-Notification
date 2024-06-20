# 2024-NC2-M29-Notification
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About Augmented Reality
앱이 백그라운드에서 실행 중이든 비활성 상태이든 사람들에게 각 시기에 적절하고 관련성 있는 정보를 한 눈에 알아볼 수 있는 짧은 컨텐츠(정보)를 제공하는 역할을 합니다.

사용자 알림을 관리하는 프레임워크인 UserNotification의 핵심 클래스 UNUserNotificationCenter를 이용합니다. 이 클래스는 로컬 및 원격 알림을 예약하고 전달하는 역할을 합니다.

- **알림의 구성**
  
  제목, 부제목, 본문과 같이 배너 창에 뜨는 정보를 기본적으로 설정할 수 있습니다. </br>
  알림 소리, 알림 뱃지에 표기할 숫자, 알림 자체에 관련된 데이터 등도 추가해 다양하게 알림을 구성할 수 있습니다.

- **트리거**
  - **로컬**: 기기 자체의 상태와 연결지어 알림을 보낼 수 있습니다. 크게는 세가지로, 특정 날짜&시간, 일정 시간 간격, 장소 진입&외출 의 상태에 따라 알림을 트리거할 수 있습니다.
  - **원격**: 서버에서 푸시하는 알림으로, 서버를 통해 원하는 때에 원하는 내용으로 알림을 트리거할 수 있습니다.

 - **알림의 전달과 처리**
   
   UNUserNotificationCenterDelegate 프로토콜을 채택하여 알림을 받았을 때의 행동을 정의할 수 있습니다. </br>
   UNNotificationCategory와 UNNotificationAction을 사용하여 알림에 액션 버튼을 추가할 수 있습니다. 


## 🎯 What we focus on?
Date Trigger를 이용한 Local notification을 기반으로, Actionable Notifications을 활용한 상호작용을 이해하고, 이용해보는 것에 집중했습니다.

## 💼 Use Case
**알림을 통해 퀴즈를 내고, 유저의 앱 유입률을 늘리자!**

기업(쿠팡)에서 알림를 통해 퀴즈를 출제하고, 알림을 꾹 눌러 퀴즈를 풀 수 있습니다.. 이렇게 퀴즈를 맞추면 경품 추첨의 기회를 주며 앱에 진입하도록 하여 앱 사용률을 높히려 합니다..

## 🖼️ Prototype
(프로토타입과 설명 추가)

## 🛠️ About Code
- 퀴즈 정보를 받아 알림을 추가하는 코드입니다. 알림에 관한 내용은 모두 NotificationManager 클래스를 만들어 관리하고 있습니다.
  ```swift
    func scheduleQuizNotification(quiz: Quiz, quizIndex: Int) {
        var content = makeNotificationContent(quiz: quiz, quizIndex: quizIndex)
        
        let categoryIdentifier = "QUIZ_CATEGORY"
        content.categoryIdentifier = categoryIdentifier
        addActionButton(quiz: quiz, categoryIdentifier: categoryIdentifier)
        
        let trigger = makeNotificationDateTrigger(date: quiz.date, isRepeated: false)
        
        let request = UNNotificationRequest(identifier: quiz.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
  ```
- 퀴즈 정보를 바탕으로 알림의 내용(제목, 본문, 소리, 뱃지, 관련 데이터)을 구성합니다.
  ```swift
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
  ```
- 퀴즈 정보를 바탕으로 알림의 액션 버튼을 추가합니다.
  ```swift
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
  ```
- 퀴즈 정보의 Date를 통해 알림의 Trigger를 생성합니다.
  ```swift
    func makeNotificationDateTrigger(date: Date, isRepeated: Bool) -> UNNotificationTrigger {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: isRepeated)
    }
  ```
- 사용자가 선택한 액션 버튼에 따라 결과를 처리합니다.
  ```swift
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
  ```
