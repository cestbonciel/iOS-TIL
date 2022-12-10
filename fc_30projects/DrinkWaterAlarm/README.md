# 물 마시기 알람 앱
> Local Notification
* identifier
- **UNMutableNotificationContent**
- **Trigger**
    - UNCalendarNotificationTrigger
    - UNTimeIntervalNotificationTrigger
    - UNLocationNotificationTrigger

               ⬇ 전송 
> UNNotificationCenter

<hr/>

# trouble Shooting
테이블 셀의 로우를 다 지우면 fatal Error: index out of range 오류가 뜬다.
```swift
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
        self.alerts.remove(at: indexPath.row)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])

        tableView.reloadData()
        return 
    default:
        break
    }
}
```

> 수정코드
```swift
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
        self.alerts.remove(at: indexPath.row)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
        tableView.reloadData()
        
    default:
        break
    }
}
```
순서를 바꾸고, RETURN 을 지웠다. 어떤 코드가 영향을 줬을지 다시 고민해봐야한다... 


# 요약 
1. UserNotifications, NotificationCenter 라이브러리를 Import 
2. 셀의 indexPath.row 에 uuid 값을 준다.
3. 스위치 on / off 에 따라 알림 켰다 껐다 설정해주기