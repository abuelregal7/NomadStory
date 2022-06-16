//
//  ApiServiceTest.swift
//  POMACTests
//
//  Created by Ahmed on 5/30/22.
//

@testable import POMAC
import XCTest
import Combine

class ApiServiceTest: XCTestCase {
    
    // MARK: - Properties
    
    var sut: HomeAPIProtocol!
    
    // Set AnyCancellable like disposeBag
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - SetUp
    override func setUp() {
        super.setUp()
        sut = HomeAPI(networkRequest: NativeRequestable(), environment: .production)
    }
    
    // MARK: - Tear Down
    override func tearDown() {
        // This will run after each test, followed by tearDownWithError(). Override this method to perform any per-test cleanup.
        sut = nil
        
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = HomeAPI(networkRequest: NativeRequestable(), environment: .production)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        
    }
    
    func testViewModelService() {
        
        let expectation = XCTestExpectation(description: "Data Downloaded") // Api is async operation so thats's why we are using XCTestExpectation to be able towait finishing
        
        var responseError : Error?
        var responseData: [HomeModel]?
        
        sut.home().sink { [weak self] (completion) in
            guard let self = self else { return }
            switch completion {
            case .failure(let error):
                
                responseError = error
                
                print("oops got an error \(error.localizedDescription)")
                
            case .finished:
                print("nothing much to do here => finished => done")
            }
        } receiveValue: { [weak self] (response) in
            
            guard let self = self else { return }
            
            responseData = response
            expectation.fulfill()
            
            print("got my response here : \(response)")
            
        }
        .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(responseError) // make sure error = nil
        XCTAssertNotNil(responseData) // make sure responseData != nil
        
    }
    

}
