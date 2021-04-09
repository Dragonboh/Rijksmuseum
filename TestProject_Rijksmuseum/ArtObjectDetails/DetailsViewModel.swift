//
//  DetailsViewModel.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

protocol DetailsViewModelProtocol: class {
  func loadDetailsData()
}

protocol DetailsViewModelDelegateProtocol: class {
  func onDetailsDataLoadCompleted(result: Result<ArtObject, Swift.Error>)
}

class DetailsListViewModel {
  private var dataModel: DetailsModelProtocol
  
  // Your viewController
  weak var delegate: DetailsViewControllerDelegate?
  private let objectNumber: String
  
  init(dataModel: DetailsModelProtocol,
       objectNumber: String) {
    self.dataModel = dataModel
    self.objectNumber = objectNumber
  }
  
  private func prepareDisplayModel(from data:ArtObjectDetails) -> DisplayDetailsArtObject {
    let description = data.description
    let objectNumber = self.objectNumber
    let identification = DisplayDetailsArtObject.Identification(description: description, objectNumber: objectNumber)
    
    let title = data.longTitle
    let subtitle = data.physicalMedium + " " + data.subTitle
    let titleDescription = data.label.description
    let imageUrl = data.webImage.url
    let displayModel = DisplayDetailsArtObject (title: title, subtitle: subtitle, titleDescription: titleDescription, imageUrl: imageUrl, identification: identification)
    
    return displayModel
  }
}

// MARK: - DetailsViewModelProtocol
extension DetailsListViewModel: DetailsViewModelProtocol {
  func loadDetailsData() {
    dataModel.loadDetailsData(objectNumber: objectNumber)
  }
}

// MARK: - DetailsViewModelDelegateProtocol
extension DetailsListViewModel: DetailsViewModelDelegateProtocol {
  func onDetailsDataLoadCompleted(result: Result<ArtObject, Swift.Error>) {
    switch result {
    case .failure(let error) :
      DispatchQueue.main.async { [weak self] in
        self?.delegate?.displayDetailsDataLoadError(error: error)
      }
    case .success(let artObject):
      let displayModel = prepareDisplayModel(from: artObject.artObject)
      
      DispatchQueue.main.async { [weak self] in
        self?.delegate?.displayDetailsArtObject(displayModel)
      }
    }
  }
}
