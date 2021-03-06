// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import Foundation

@available(OSX 10.14, iOS 12.0, *)
class TunnelConfiguration: Codable {
    var interface: InterfaceConfiguration
    var peers: [PeerConfiguration] = []
    init(interface: InterfaceConfiguration) {
        self.interface = interface
    }
}

@available(OSX 10.14, iOS 12.0, *)
struct InterfaceConfiguration: Codable {
    var name: String
    var privateKey: Data
    var addresses: [IPAddressRange] = []
    var listenPort: UInt16?
    var mtu: UInt16?
    var dns: [DNSServer] = []

    init(name: String, privateKey: Data) {
        self.name = name
        self.privateKey = privateKey
        if (name.isEmpty) { fatalError("Empty name") }
        if (privateKey.count != 32) { fatalError("Invalid private key") }
    }
}

@available(OSX 10.14, iOS 12.0, *)
struct PeerConfiguration: Codable {
    var publicKey: Data
    var preSharedKey: Data? {
        didSet(value) {
            if let value = value {
                if (value.count != 32) { fatalError("Invalid preshared key") }
            }
        }
    }
    var allowedIPs: [IPAddressRange] = []
    var endpoint: Endpoint?
    var persistentKeepAlive: UInt16?

    init(publicKey: Data) {
        self.publicKey = publicKey
        if (publicKey.count != 32) { fatalError("Invalid public key") }
    }
}
