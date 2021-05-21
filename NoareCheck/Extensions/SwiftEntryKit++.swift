//
//  SwiftEntryKit++.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/21.
//

import SwiftEntryKit
import UIKit
import SwifterSwift

enum ToastType {
    case alert
    case warning
    case error

    var name: String {
        switch self {
        case .alert:
            return "AlertToast"
        case .warning:
            return "WarningToast"
        case .error:
            return "ErrorToast"
        }
    }

    var hapticFeedbackType: EKAttributes.NotificationHapticFeedback {
        switch self {
        case .alert:
            return .none
        case .warning:
            return .warning
        case .error:
            return .error
        }
    }

    var displayDuration: EKAttributes.DisplayDuration {
        switch self {
        case .alert, .warning:
            return 5
        case .error:
            return .infinity
        }
    }

    var entryBackground: EKAttributes.BackgroundStyle {
        switch self {
        case .alert, .warning, .error:
            return .visualEffect(style: .standard)
        }
    }
}

typealias AlertID = UUID

extension AlertID {
    func dismissAlert(completionHandler: (() -> Void)? = nil) {
        SwiftEntryKit.dismiss(.specific(entryName: uuidString), with: completionHandler)
    }
}

enum Toast {
    static func showToast(title: String = "", message: String?, toastType: ToastType = .alert,
                         position: EKAttributes.Position = .bottom, displayDuration: EKAttributes.DisplayDuration? = nil)
    {
        guard title.isNotEmpty || !message.isNilOrEmpty else { return }
        var attributes = EKAttributes()
        attributes.name = toastType.name
        if let value = displayDuration {
            attributes.displayDuration = value
        } else {
            attributes.displayDuration = toastType.displayDuration
        }
        attributes.entryBackground = toastType.entryBackground
        attributes.position = position
        attributes.positionConstraints.safeArea = position == .center ? .overridden : .empty(fillSafeArea: true)
        attributes.hapticFeedbackType = toastType.hapticFeedbackType
        attributes.entranceAnimation = position == .center ? .init(fade: .init(from: 0, to: 1, duration: 0.25)) : .translation
        attributes.exitAnimation = position == .center ? .init(fade: .init(from: 1, to: 0, duration: 0.25)) : .translation
        attributes.positionConstraints.size = position == .center ? .init(width: .offset(value: 32), height: .intrinsic) : .sizeToWidth
        attributes.roundCorners = .all(radius: 8)

        let simpleMessage = EKSimpleMessage(title: .init(text: title, style: .init(font: .systemFont(ofSize: 16), color: .standardContent)),
                                            description: .init(text: message ?? "",
                                                               style: .init(font: .systemFont(ofSize: 14), color: .standardContent,
                                                                            alignment: .center)))

        var insets = EKNotificationMessage.Insets.default
        insets.contentInsets = .init(top: 8, left: 16, bottom: position == .center ? 16 : 8, right: 16)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage, insets: insets)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
