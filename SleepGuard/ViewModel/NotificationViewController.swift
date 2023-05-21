//
//  NotificationViewController.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 22/05/23.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required UI configuration here.
    }

    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        // Configure UI elements based on the notification content.
        if let attachment = content.attachments.first, attachment.identifier == "your_attachment_identifier" {
            if attachment.url.startAccessingSecurityScopedResource() {
                if let imageData = try? Data(contentsOf: attachment.url) {
                    imageView.image = UIImage(data: imageData)
                }
                attachment.url.stopAccessingSecurityScopedResource()
            }
        }
    }
}
