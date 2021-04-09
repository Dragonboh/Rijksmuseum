//
//  Router.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation
import UIKit

protocol Routing {
  func start() -> UIViewController
}

class AppRouter: Routing {
  
  @discardableResult
  func start() -> UIViewController {
    
    let model = ListModel(networkService: NetworkService())
    let viewModel = ListViewModel(dataModel: model)
    let vc = MuseumCollectionViewController.instantiate()
    
    vc.viewModel = viewModel
    viewModel.delegate = vc
    model.delegate = viewModel
    
    let navigation = UINavigationController(rootViewController: vc)
    
    viewModel.showDetails = { [weak self] objectNumber in
      self?.showArtObjectDetails(objectNumber, in: navigation)
    }
    
    return navigation
  }
  
  private func showArtObjectDetails(_ objectNumber: String, in navigation: UINavigationController) {
    let model = DetailsModel(networkService: NetworkService())
    let viewModel = DetailsListViewModel(dataModel: model, objectNumber: objectNumber)
    let vc = DetailsViewController.instantiate()
    
    vc.viewModel = viewModel
    viewModel.delegate = vc
    model.delegate = viewModel
    
    navigation.pushViewController(vc, animated: true)
  }
}
