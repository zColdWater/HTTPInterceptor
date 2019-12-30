import XCTest
import BestHttpInterceptor

extension Tests: HttpMockerDelegate {
    func httpMocker(request: URLRequest) -> HttpMocker {
        guard let url = request.url else { fatalError() }
        switch url {
        case mockUrl:
            let string: String = "111"
            let data = try! JSONSerialization.data(withJSONObject: string, options: [.prettyPrinted,.fragmentsAllowed])
            return HttpMocker.init(dataType: .json, mockData: data, statusCode: 200, httpVer: .http1_1, headerFields: nil)
        default:
            fatalError()
        }
    }
}

extension Tests: HttpInterceptDelegate {
    func httpRequest(request: URLRequest) -> URLRequest {
        return request
    }
    func httpRequest(response: URLResponse) -> URLResponse {
        return response
    }
    func httpRequest(request: URLRequest, data: Data) -> Data {
        let fakeStr = "0000".data(using: .utf8)
        return fakeStr!
    }
    func httpRequest(request: URLRequest, didCompleteWithError error: Error?) {
    }
    func httpRequest(request: URLRequest, didFinishCollecting metrics: URLSessionTaskMetrics) {
    }
}


let mockUrl: URL = URL(string: "https://mocker.example.com/")!
let interceptorUrl: URL = URL(string: "https://httpbin.org/get")!


class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        print("XCTestCase setUp")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        print("XCTestCase tearDown")
    }
    
    // Test Interceptor API 是否正常
    func testInterceptorInterface() {
        let condition = HttpIntercepCondition.init(schemeType: .all) { (request) -> Bool in
            return true
        }
        let interceptor = HttpInterceptor(condition: condition, mockerDelegate: self)
        interceptor.register()
        interceptor.unregister()
    }
    
    // Test Mocker API 是否正常
    func testMockerInterface() {
        let condition = HttpIntercepCondition.init(schemeType: .all) { (request) -> Bool in
            return true
        }
        let interceptor = HttpInterceptor(condition: condition, interceptorDelegate: self)
        interceptor.register()
        interceptor.unregister()
    }
    
    // Test HttpIntercepCondition schemeType 是否有效，只回调https协议
    func testCondition1() {
        // https
        let condition1 = HttpIntercepCondition.init(schemeType: .https) { (request) -> Bool in
            if let schem = request.url?.scheme {
                XCTAssert(schem == "https")
            }
            return true
        }
        let interceptor1 = HttpInterceptor(condition: condition1, interceptorDelegate: self)
        interceptor1.register()
        
        let httpURL = URL(string: "http://example.com")!
        URLSession.shared.dataTask(with: httpURL).resume()
        
        let httpsURL = URL.init(string: "https://example.com")!
        URLSession.shared.dataTask(with: httpsURL).resume()
    }
    
    // Test HttpIntercepCondition schemeType 是否有效，只回调http协议
    func testCondition2() {
        // http
        let condition = HttpIntercepCondition.init(schemeType: .http) { (request) -> Bool in
            if let scheme = request.url?.scheme {
                XCTAssert(scheme == "http")
            }
            return true
        }
        let interceptor = HttpInterceptor(condition: condition, interceptorDelegate: self)
        interceptor.register()
        
        let httpURL = URL(string: "http://example.com")!
        URLSession.shared.dataTask(with: httpURL).resume()
        
        let httpsURL = URL(string: "https://example.com")!
        URLSession.shared.dataTask(with: httpsURL).resume()
    }
    
    // Test Mocker 是否工作正常
    func testMocker1() {
        let expectation = self.expectation(description: "Mock Data should succeed")
        let expectationResult: String = "\"111\""
        let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
            if let url = request.url, url == mockUrl {
                return true
            } else {
                return false
            }
        }
        let interceptor = HttpInterceptor(condition: condition, mockerDelegate: self)
        interceptor.register()
        URLSession.shared.dataTask(with: mockUrl) { (data, response, error) in
            let jsonStr = String(data: data!, encoding: .utf8)!
            XCTAssert(jsonStr == expectationResult,"jsonStr == expectationResult should be")
            expectation.fulfill()
        }.resume()
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    // Test 拦截器 是否正常工作
    func testInterceptor1() {
        let expectation = self.expectation(description: "Interceptor Request should succeed")
        let condition = HttpIntercepCondition(schemeType: .all) { (request) -> Bool in
            if let url = request.url, url == interceptorUrl {
                return true
            } else {
                return false
            }
        }
        let interceptor = HttpInterceptor(condition: condition, interceptorDelegate: self)
        interceptor.register()
        URLSession.shared.dataTask(with: interceptorUrl) { (data, response, error) in
            let result: String = String(data: data!, encoding: .utf8)!
            XCTAssert(result == "0000")
            expectation.fulfill()
        }.resume()
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPerformanceExample() {
        self.measure() {
            print("XCTestCase testPerformanceExample")
        }
    }
    
}
