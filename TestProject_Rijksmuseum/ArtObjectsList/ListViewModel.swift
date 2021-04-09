//
//  ArtObjectsListViewModel.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

protocol ArtObjectsListViewModelProtocol: class {
  func loadData(page: Int)
  func onDataLoadCompleted(result: Result<MuseumArtObjects, Swift.Error>)
  func showArtObjectDetails(index: Int)
}

class ArtObjectsListViewModel: ArtObjectsListViewModelProtocol {
  private(set) var dataModel: ArtObjectsListModelProtocol
  
  // Your viewController
  weak var delegate: CollectionViewControllerProtocol?
  private var data = [MuseumArtObject]()
  
  init(dataModel: ArtObjectsListModelProtocol) {
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
  
  func showArtObjectDetails(index: Int) {
    showDetails?(data[index].objectNumber)
  }
  
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
        self?.delegate?.displayArtObjects(displayModel)
      }
    }
  }
  
  func loadData(page: Int) {
    dataModel.loadData(page: page)
  }
}
