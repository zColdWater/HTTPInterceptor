import UIKit

@objc public enum InterceptSchemeType: NSInteger {
    case https = 0
    case http
    case all // https + http
}

@objc public class HttpIntercepCondition: NSObject {
    
    public typealias MatchCondition = (URLRequest) -> Bool
    @objc public var interceptSchemeType: InterceptSchemeType = .https
    @objc public var matchRequest: MatchCondition?
    
    @objc public init(schemeType: InterceptSchemeType, condition: MatchCondition?) {
        self.interceptSchemeType = schemeType
        super.init()
        self.matchRequest = condition
    }
}

extension HttpIntercepCondition {
    class func convertSchemeType(scheme: String) -> InterceptSchemeType? {
        switch scheme {
        case "http":
            return InterceptSchemeType.http
        case "https":
            return InterceptSchemeType.https
        default:
            return nil
        }
    }
}
