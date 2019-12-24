import Foundation

enum ContentType: Int {
    case httpReuestURL = 0
    case httpRequestHeader
    case httpRequestQueryString
    case httpRequestBody
    case httpResponseHeader
    case httpResponseBody
    
    case httpIntercepingRequest
    case httpIntercepingResponse
    case httpIntercepingMetrics
    
    static func getSectionHeaderText(index: Int) -> String {
        guard let type = ContentType(rawValue: index) else {
            return "None"
        }
        switch type {
        case .httpReuestURL:
            return "Reuqest URL"
        case .httpRequestHeader:
            return "Request Header"
        case .httpRequestQueryString:
            return "Request QueryString"
        case .httpRequestBody:
            return "Request Body"
        case .httpResponseHeader:
            return "Response Header"
        case .httpResponseBody:
            return "Response Body"

        case .httpIntercepingRequest:
            return "拦截 Request"
        case .httpIntercepingResponse:
            return "拦截 Response"
        case .httpIntercepingMetrics:
            return "拦截 Metrics"
        }
    }
}
