//
//  ArtObjectListModel.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

protocol ListModelProtocol: class {
  func loadData(page: Int)
}

class ListModel {
  private(set) var networkService: NetworkServiceProtocol
  
  // Your viewModel
  weak var delegate: ListViewModelDelegateProtocol?
  
  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
}

// MARK: - ListModelProtocol
extension ListModel: ListModelProtocol {
  func loadData(page: Int) {
    networkService.getArtObjects(page: page) { [weak self] result in
      self?.delegate?.onDataLoadCompleted(result: result)
    }
  }
}
