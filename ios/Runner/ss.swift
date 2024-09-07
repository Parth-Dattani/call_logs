import CallKit

class CallObserver: NSObject, CXCallObserverDelegate {
    let methodChannel: FlutterMethodChannel

    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }

    func startCallObserver() {
        let callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
    }

    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        let callEventData: [String: Any] = [
            "callUUID": call.uuid.uuidString,
            "isOutgoing": call.isOutgoing,
            "hasConnected": call.hasConnected,
            // Add more call event data as needed
        ]

        methodChannel.invokeMethod("onCallEvent", arguments: callEventData)
    }
}
