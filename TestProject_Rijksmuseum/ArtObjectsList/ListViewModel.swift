//
//  ArtObjectsListViewModel.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

protocol ListViewModelProtocol: class {
  func loadData()
  func showArtObjectDetails(index: Int)
  func loadNextPageData()
}

protocol ListViewModelDelegateProtocol: class {
  func onDataLoadCompleted(result: Result<MuseumArtObjects, Swift.Error>)
}

class ListViewModel {
  private(set) var dataModel: ListModelProtocol
  
  // Your viewController
  weak var delegate: CollectionViewControllerProtocol?
  private var data = [MuseumArtObject]()
  private var currentPage = 1
  
  init(dataModel: ListModelProtocol) {
    self.dataModel = dataModel
  }
  
  var showDetails: ((String) -> Void)?
  
  private func prepareDisplayModel(from data:[MuseumArtObject]) -> [DisplayArtObject] {
    var displayModel = [DisplayArtObject]()
    for obj in data {
      var url = obj.webImage.url
      url.remove(at: url.index(before: url.endIndex))
      url.append("500")
      displayModel.append(DisplayArtObject.init(title: obj.title, url: url))
    }
    return displayModel
  }
}

// MARK: - ListViewModelDelegateProtocol
extension ListViewModel: ListViewModelDelegateProtocol {
  func onDataLoadCompleted(result: Result<MuseumArtObjects, Swift.Error>) {
    switch result {
    case .failure(let error) :
      DispatchQueue.main.async { [weak self] in
        self?.delegate?.displayDataLoadError(error: error)
      }
    case .success(let artObjects):
      print("result found")
      let displayModel = prepareDisplayModel(from: artObjects.artObjects)
      data.append(contentsOf: artObjects.artObjects)
      
      DispatchQueue.main.async { [weak self] in
        self?.currentPage == 1
          ? self?.delegate?.displayInitialArtObjects(displayModel)
          : self?.delegate?.displayNextArtObjects(displayModel)
      }
    }
  }
}

// MARK: - ListViewModelProtocol
extension ListViewModel: ListViewModelProtocol {
  func showArtObjectDetails(index: Int) {
    showDetails?(data[index].objectNumber)
  }
  
  func loadData() {
    dataModel.loadData(page: currentPage)
  }
  
  func loadNextPageData() {
    currentPage += 1
    loadData()
  }
}
