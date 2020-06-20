import UIKit

@objc(YandexLogin)
class YandexLogin: NSObject {
    
    @objc(timeToStartCheckout:)
    func timeToStartCheckout(testMode: Bool) -> Void {
        
    }
    
    @objc
    func constantsToExport() -> [String: Any]! {
        return ["someKey": "someValue"]
    }
    
}
