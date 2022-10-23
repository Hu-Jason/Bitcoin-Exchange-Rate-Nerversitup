//
//  BTCNetworkMonitor.swift
//  Bitcoins
//
//  Created by SukPoet on 2022/10/23.
//

import Network

class BTCNetworkMonitor {
    static let shared = BTCNetworkMonitor()
    var isReachable: Bool { status == .satisfied }
    
    private let monitor = NWPathMonitor()
    private var status = NWPath.Status.requiresConnection
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
        let queue = DispatchQueue(label: "BTCNetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
