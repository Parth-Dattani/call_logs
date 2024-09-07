//
//  SwiftCallLogObserver.swift
//  Runner
//
//  Created by Mac Mini1 on 07/05/24.
//

import Foundation
import CallKit

public class SwiftCallLogObserver: NSObject, FlutterPlugin, CXCallObserverDelegate {
    var callObserver: CXCallObserver!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "call_log_channel", binaryMessenger: registrar.messenger())
        let instance = SwiftCallLogObserver()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "startCallLogObserver" {
            startCallLogObserver()
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    func startCallLogObserver() {
        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
    }

    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            // Handle call ended event
            print("Call ended")
        } else if call.isOutgoing == true && call.hasConnected == false {
            // Handle outgoing call initiated event
            print("Outgoing call initiated")
        } else if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            // Handle incoming call event
            print("Incoming call")
        } else if call.hasConnected == true && call.hasEnded == false {
            // Handle call connected event
            print("Call connected")
        }
    }
}

