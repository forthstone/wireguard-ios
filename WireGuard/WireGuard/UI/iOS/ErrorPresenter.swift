// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import UIKit
import os.log

class ErrorPresenter {
    static func errorMessage(for error: Error) -> (String, String)? {
        switch (error) {

        // TunnelManagementError
        case TunnelManagementError.tunnelAlreadyExistsWithThatName:
            return ("Name already exists", "A tunnel with that name already exists")
        case TunnelManagementError.tunnelInvalidName:
            return ("Name already exists", "The tunnel name is invalid")
        case TunnelManagementError.vpnSystemErrorOnAddTunnel:
            return ("Unable to create tunnel", "Internal error")
        case TunnelManagementError.vpnSystemErrorOnModifyTunnel:
            return ("Unable to modify tunnel", "Internal error")
        case TunnelManagementError.vpnSystemErrorOnRemoveTunnel:
            return ("Unable to remove tunnel", "Internal error")

        // TunnelActivationError
        case TunnelActivationError.dnsResolutionFailed:
            return ("DNS resolution failure", "One or more endpoint domains could not be resolved")
        case TunnelActivationError.tunnelActivationFailed:
            return ("Activation failure", "The tunnel could not be activated due to an internal error")
        case TunnelActivationError.attemptingActivationWhenAnotherTunnelIsBusy(let otherTunnelStatus):
            let statusString: String = {
                switch (otherTunnelStatus) {
                case .active: fallthrough
                case .reasserting:
                    return "active"
                case .activating: fallthrough
                case .deactivating:
                    return "being deactivated"
                case .inactive:
                    fatalError()
                }
            }()
            return ("Activation failure", "Another tunnel is currently \(statusString)")

        default:
            os_log("ErrorPresenter: Error not presented: %{public}@", log: OSLog.default, type: .error, "\(error)")
            return nil
        }
    }

    static func showErrorAlert(error: Error, from sourceVC: UIViewController?,
                               onDismissal: (() -> Void)? = nil, onPresented: (() -> Void)? = nil) {
        guard let sourceVC = sourceVC else { return }
        guard let (title, message) = ErrorPresenter.errorMessage(for: error) else { return }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            onDismissal?()
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)

        sourceVC.present(alert, animated: true, completion: onPresented)
    }

    static func showErrorAlert(title: String, message: String, from sourceVC: UIViewController?, onDismissal: (() -> Void)? = nil) {
        guard let sourceVC = sourceVC else { return }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            onDismissal?()
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)

        sourceVC.present(alert, animated: true)
    }
}
