//
//  TestProject_RijksmuseumTests.swift
//  TestProject_RijksmuseumTests
//
//  Created by Bogdan Pankevych on 05.04.2021.
//

import XCTest
@testable import TestProject_Rijksmuseum

//class MockArtObjectsListModel: ArtObjectsListModelProtocol {
//  func loadData(page: Int) {}
//}

class MockNetworkService: NetworkServiceProtocol {

  func getArtObjectDetails(objectNumber: String, completion: @escaping (Result<ArtObject, Swift.Error>) -> Void) {
  
  }
  
  var artObjects: [MuseumArtObject] = []
  
  func getArtObjects(page: Int, completion: @escaping (Result<MuseumArtObjects, Swift.Error>) -> Void) {
    completion(.success(MuseumArtObjects(artObjects: artObjects)))
  }
}

class DisplayResultController: CollectionViewControllerProtocol {

  var error: Error?
  var loadedObjects: [DisplayArtObject] = []
  
  func displayArtObjects(_ viewModel: [DisplayArtObject]) {
    loadedObjects = viewModel
  }
  
  func displayDataLoadError(error: Error) {
    self.error = error
  }
}

class TestProject_RijksmuseumTests: XCTestCase {
  var viewModel: ArtObjectsListViewModel!
  var networkService = MockNetworkService()
  lazy var data = ArtObjectsListModel(networkService: networkService)
  var displayResultController = DisplayResultController()
  
  override func setUpWithError() throws {
    viewModel = ArtObjectsListViewModel(dataModel: data, viewController: displayResultController)
    data.delegate = viewModel
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testReturnEmptyArray() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    viewModel.loadData(page: 0)
    XCTAssertTrue(displayResultController.error == nil)
    XCTAssertTrue(displayResultController.loadedObjects.count == 0)
  }
  
  func testReceiveTenObjects() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    for _ in 0...9 {
      networkService.artObjects.append(MuseumArtObject(title: "", objectNumber: "", webImage: WebImage(guid: "", width: 0, height: 0, url: "asd")))
    }
  
    

    //_ = self.expectation(description: "Scaling")
    viewModel.loadData(page: 0)
    //waitForExpectations(timeout: 5, handler: nil)
  
    XCTAssertTrue(displayResultController.error == nil)
    XCTAssertTrue(displayResultController.loadedObjects.count == 10)
    
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
