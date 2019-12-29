@objc public enum HttpMockerDataType: Int {
    case json
    case html
    case imagePNG
    case imageJPG
    case imageGIF
    case pdf
    case mp4
    case zip
}

@objc public enum HttpMockerHttpType: Int {
    case http1_0
    case http1_1
    case http2_0
}

@objc public class HttpMocker: NSObject {
    
    var statusCode: Int
    var httpVersion: HttpMockerHttpType
    var headerFields: [String: String]
    var dataType: HttpMockerDataType
    var mockData: Data
    
    var httpVersionString: String {
        switch httpVersion {
        case .http1_0:
            return "HTTP/1.0"
        case .http1_1:
            return "HTTP/1.1"
        case .http2_0:
            return "HTTP/2.0"
        }
    }
    
    @objc public init(dataType: HttpMockerDataType,
                      mockData: Data,
                      statusCode: Int,
                      httpVer: HttpMockerHttpType,
                      headerFields: [String: String]? = nil) {
        self.statusCode = statusCode
        self.httpVersion = httpVer
        self.headerFields = headerFields ?? [:]
        self.dataType = dataType
        self.mockData = mockData
        super.init()
        
        self.headerFields["Content-Type"] = self.dataTypeConvertString(dataType: dataType)
    }
    
    internal func dataTypeConvertString(dataType: HttpMockerDataType) -> String {
        switch dataType {
        case .html:
            return "text/html; charset=utf-8"
        case .imageGIF:
            return "image/gif"
        case .imageJPG:
            return "image/jpeg"
        case .imagePNG:
            return "image/png"
        case .json:
            return "application/json; charset=utf-8"
        case .mp4:
            return "video/mp4"
        case .pdf:
            return "application/pdf"
        case .zip:
            return "application/zip"
        }
    }
}
