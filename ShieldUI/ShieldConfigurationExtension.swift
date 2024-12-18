//
//  ShieldConfigurationExtension.swift
//  ShieldUI
//
//  Created by Brett Nguyen  on 3/17/24.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemMaterialLight,
            backgroundColor: UIColor(red: 0.71, green: 0.66, blue: 0.98, alpha: 1.00),
            icon: nil,
            title: ShieldConfiguration.Label(text: "Life is short.", color: .black),
            subtitle: ShieldConfiguration.Label(text: "Hello Brett.", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Thanks!", color: .white),
            primaryButtonBackgroundColor: UIColor.black,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Break 👀", color: .black)
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemMaterialLight,
            backgroundColor: UIColor(red: 0.71, green: 0.66, blue: 0.98, alpha: 1.00),
            icon: nil,
            title: ShieldConfiguration.Label(text: "Life is short.", color: .black),
            subtitle: ShieldConfiguration.Label(text: "But if you wanna use this app, let’s make sure to pay.", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Thanks!", color: .white),
            primaryButtonBackgroundColor: UIColor.black,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Break 👀", color: .black)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
