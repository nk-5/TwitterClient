//
//  ProgressHUD.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/18.
//

import Foundation
import MBProgressHUD

class ProgressHUD: MBProgressHUD {
    static func showDoneAlert(to view: UIView, text: String, completion: (() -> Void)? = nil) {
        MBProgressHUD.hide(for: view, animated: true)

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.customView = UIImageView(image: UIImage(systemName: "checkmark"))
        hud.label.text = text

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion?()
            MBProgressHUD.hide(for: view, animated: true)
        }
    }

    static func showErrorAlert(to view: UIView, errorText: String, completion: (() -> Void)? = nil) {
        MBProgressHUD.hide(for: view, animated: true)

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.customView = UIImageView(image: UIImage(systemName: "xmark.icloud.fill"))
        hud.label.text = errorText

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion?()
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}
