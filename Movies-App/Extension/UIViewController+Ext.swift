//
//  UIViewController+Ext.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation
import UIKit
import SnapKit

let indicatorParentViewTag = 999

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }

    func showHUD(rootWindow: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) {
        var controller = rootWindow ?? self
        if !controller.isKind(of: UINavigationController.self) {
            controller = controller.navigationController ?? self
        }
        guard controller.view.subviews.contains(where: { $0.tag == indicatorParentViewTag }) != true else {
            controller.view.subviews.forEach { view in
                if view.tag == indicatorParentViewTag {
                    let transparentView = UIView(frame: .zero)
                    transparentView.accessibilityIdentifier = String(describing: self)
                    transparentView.backgroundColor = .clear
                    view.insertSubview(transparentView, at: 0)
                }
            }
            return
        }
        let containerView = UIView()
        containerView.accessibilityIdentifier = String(describing: self)
        containerView.tag = indicatorParentViewTag
        containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3984109269)
        controller.view.addSubview(containerView)
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        containerView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        containerView.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        indicator.startAnimating()
    }

    func hideHUD(rootWindow: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) {
        let identifier = String(describing: self)
        var controller = rootWindow ?? self
        if !controller.isKind(of: UINavigationController.self) {
            controller = controller.navigationController ?? self
        }
        controller.view.subviews.forEach { view in
            if view.tag == indicatorParentViewTag {
                let subviews = view.subviews.filter { v in
                    !(v is UIActivityIndicatorView) && v.bounds == .zero
                }
                if view.accessibilityIdentifier == identifier {
                    if subviews.isEmpty {
                        view.removeFromSuperview()
                    } else {
                        view.accessibilityIdentifier = subviews[0].accessibilityIdentifier
                        subviews[0].removeFromSuperview()
                    }
                } else {
                    let svs = subviews.filter { v in
                        v.accessibilityIdentifier == identifier
                    }
                    if !svs.isEmpty {
                        svs[0].removeFromSuperview()
                    }
                }
            }
        }
    }
}
