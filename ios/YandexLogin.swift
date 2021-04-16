import UIKit

@objc(YandexLogin)
class YandexLogin: NSObject, YXLObserver {
    var storedResolver: RCTPromiseResolveBlock?
    var storedRejecter: RCTPromiseRejectBlock?
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    func timeToStartCheckout(_ id: NSString,
                             resolver: @escaping RCTPromiseResolveBlock,
                             rejecter: @escaping RCTPromiseRejectBlock) -> Void {
        self.storedResolver = resolver
        self.storedRejecter = rejecter
        
        YXLSdk.shared.add(observer: self)
        DispatchQueue.main.async {
            YXLSdk.shared.authorize()
        }
    }
    
    @objc(activate:)
    func activate(id: String) -> Void {
        do{
            try YXLSdk.shared.activate(withAppId: id)
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func loginDidFinish(with result: YXLLoginResult) {
        if let resolver = self.storedResolver {
            resolver([
                result.token,
                result.jwt
                ])
        }
        YXLSdk.shared.remove(observer: self)
    }
    
    func loginDidFinishWithError(_ error: Error) {
        if let rejecter = self.storedRejecter {
            rejecter(stringForError(error), "", error)
        }
        YXLSdk.shared.remove(observer: self)
    }
    
    private func stringForError(_ error: Error) -> String {
         guard (error as NSError).domain == kYXLErrorDomain, let code = YXLErrorCode(rawValue: (error as NSError).code) else {
             return String(describing: error)
         }
         switch code {
         case .notActivated:
             return "Sdk is not activated"
         case .cancelled:
             return "Authorization controller closed by user"
         case .denied:
             return "User denied access in permissions page"
         case .invalidClient:
             return "AppId authentication failed"
         case .invalidScope:
             return "The requested scope is invalid, unknown, or malformed"
         case .other:
             return "Other error " + String(describing: error)
         case .requestError:
             return "Internal HTTP request error"
         case .requestConnectionError:
             return "HTTP internet connection error"
         case .requestSSLError:
             return "HTTP SSL error"
         case .requestNetworkError:
             return "Other HTTP error"
         case .requestResponseError:
             return "Bad response for HTTP request (not NSHTTPURLResponse or status code not in 200..299)"
         case .requestEmptyDataError:
             return "Empty data returns on some HTTP request"
         case .requestTokenError:
             return "Bad answer for token request"
         case .requestJwtError:
             return "Bad answer for jwt request"
         case .requestJwtInternalError:
             return "Jwt request internal error"
         case .invalidState:
             return "Invalid state parameter"
         case .invalidCode:
             return "Invalid authorization code"
         }
     }
}
