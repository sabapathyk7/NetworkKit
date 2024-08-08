import Combine
import XCTest
@testable import NetworkKit

final class NetworkServiceTests: XCTestCase {
    private var networkService: NetworkService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        networkService = NetworkService()
        cancellables = []
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    override func tearDown() {
        networkService = nil
        cancellables = nil
        URLProtocol.unregisterClass(URLProtocolMock.self)
        super.tearDown()
    }

    func testSendRequestWithURLString_Success() async throws {
        // Arrange
        let expectedData = "{\"key\":\"value\"}".data(using: .utf8)!
        let mockResponse = MockResponse(
            data: expectedData,
            response: HTTPURLResponse(url: URL(string: "https://swiftpublished.com")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil),
            error: nil
        )
        URLProtocolMock.mockResponse = mockResponse

        // Act
        let result: [String: String] = try await networkService.sendRequest(urlStr: "https://swiftpublished.com")

        // Assert
        XCTAssertEqual(result["key"], "value")
    }

    func testSendRequestWithCombine_Success() {
        // Arrange
        let expectedData = "{\"key\":\"value\"}".data(using: .utf8)!
        let mockResponse = MockResponse(
            data: expectedData,
            response: HTTPURLResponse(url: URL(string: "https://swiftpublished.com")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil),
            error: nil
        )
        URLProtocolMock.mockResponse = mockResponse

        let mockEndpoint = MockEndpoint()

        // Act
        let expectation = self.expectation(description: "Combine request should succeed")
        networkService.sendRequest(endpoint: mockEndpoint, type: [String: String].self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, got failure with \(error)")
                }
            }, receiveValue: { result in
                // Assert
                XCTAssertEqual(result["key"], "value")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2.0)
    }

    func testSendRequestWithCombine_Failure() {
        // Arrange
        let mockEndpoint = MockEndpoint()

        // Act
        let expectation = self.expectation(description: "Request should fail")
        var receivedError: NetworkError?

        networkService.sendRequest(endpoint: mockEndpoint, type: TestModel.self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Request should not succeed")
            })
            .store(in: &cancellables)

        // Assert
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(receivedError, .unknown)
    }

    func testSendRequestWithEndpoint_Failure() async {
        // Arrange
        URLProtocolMock.mockResponse = MockResponse(
            data: nil,
            response: nil,
            error: NetworkError.invalidURL
        )

        let mockEndpoint = MockEndpoint()

        // Act & Assert
        do {
            let _: [String: String] = try await networkService.sendRequest(endpoint: mockEndpoint)
            XCTFail("Expected to throw, but did not.")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }

    func testSendRequestWithResultHandler_Success() {
        // Arrange
        let expectedData = "{\"key\":\"value\"}".data(using: .utf8)!
        let mockResponse = MockResponse(
            data: expectedData,
            response: HTTPURLResponse(url: URL(string: "https://swiftpublished.com")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil),
            error: nil
        )
        URLProtocolMock.mockResponse = mockResponse

        let mockEndpoint = MockEndpoint()

        // Act
        let expectation = self.expectation(description: "Completion handler should be called")
        networkService.sendRequest(endpoint: mockEndpoint) { (result: Result<[String: String], NetworkError>) in
            switch result {
            case .success(let data):
                // Assert
                XCTAssertEqual(data["key"], "value")
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0)
    }

    func testSendRequestWithResultHandler_Failure() {
        // Arrange
        URLProtocolMock.mockResponse = MockResponse(
            data: nil,
            response: nil,
            error: NetworkError.invalidURL
        )

        let mockEndpoint = MockEndpoint()

        // Act
        let expectation = self.expectation(description: "Completion handler should be called")
        networkService.sendRequest(endpoint: mockEndpoint) { (result: Result<[String: String], NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidURL)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0)
    }
}

class URLProtocolMock: URLProtocol {
    static var mockResponse: MockResponse?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let mockResponse = URLProtocolMock.mockResponse {
            if let data = mockResponse.data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = mockResponse.response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = mockResponse.error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

struct MockResponse {
    var data: Data?
    var response: URLResponse?
    var error: Error?
}

struct MockEndpoint: EndPoint {
    var method: NetworkKit.RequestMethod {
        return .get
    }

    var header: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var body: [String : String]? {
        return [:]
    }

    var queryParams: [String : String]? {
        return [:]
    }

    var pathParams: [String : String]? {
        return [:]
    }

    var baseURL: URL {
        return URL(string: "https://swiftpublished.com")!
    }

    var path: String {
        return "/mock"
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var parameters: [String: Any]? {
        return nil
    }
}

struct TestModel: Decodable, Equatable {
    let id: Int
    let name: String
}
