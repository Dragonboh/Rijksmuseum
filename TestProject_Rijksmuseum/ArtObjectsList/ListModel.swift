//
//  ArtObjectListModel.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

protocol ArtObjectsListModelProtocol: class {
  func loadData(page: Int)
}

class ArtObjectsListModel: ArtObjectsListModelProtocol {
  private(set) var networkService: NetworkServiceProtocol
  
  // Your viewModel
  weak var delegate: ArtObjectsListViewModelProtocol?
  
  init(networkService: NetworkServiceProtocol) {
      self.networkService = networkService
  }
  
  func loadData(page: Int) {
    networkService.getArtObjects(page: page) { [weak self] result in
      self?.delegate?.onDataLoadCompleted(result: result)
    }
  }
}
