//
//  ReachabilityManager.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 01/02/2021.
//

import Foundation
import Network

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

protocol ReachabilityManagerObserver: class {
    func reachabilityDidChange(to type: ConnectionType, isConnected:Bool)
}

class ReachabilityManager {
    
    static public let shared = ReachabilityManager()
    
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    
    private(set) var isConnected: Bool = true
    private(set) var connectionType: ConnectionType = .wifi
    private var observers: [ReachabilityManagerObserver] = []
    
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }
    
    func startMonitoring() {
        self.monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            self.connectionType = self.checkConnectionTypeForPath(path)
            self.notifyObservers()
        }
    }
    
    func stopMonitoring() {
        self.monitor.cancel()
    }
    
    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }
        
        return .unknown
    }
    
    private func notifyObservers() {
        observers.forEach {
            $0.reachabilityDidChange(to: self.connectionType, isConnected: self.isConnected)
        }
    }
    
    func addObserver(_ observer: ReachabilityManagerObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: ReachabilityManagerObserver) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
        }
    }
    
}

