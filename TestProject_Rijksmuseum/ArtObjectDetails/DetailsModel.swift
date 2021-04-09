//
//  DetailsModel.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

protocol DetailsModelProtocol: class {
  func loadDetailsData(objectNumber: String)
}

class DetailsModel: DetailsModelProtocol {
  private var networkService: NetworkServiceProtocol
  
  // Your viewModel
  weak var delegate: DetailsViewModelProtocol?
  
  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  func loadDetailsData(objectNumber: String) {
    networkService.getArtObjectDetails(objectNumber: objectNumber) { [weak self] result in
      self?.delegate?.onDetailsDataLoadCompleted(result: result)
    }
  }
}
