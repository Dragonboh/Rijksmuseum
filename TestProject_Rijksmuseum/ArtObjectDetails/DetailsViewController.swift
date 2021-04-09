//
//  ArtObjectDetailsViewController.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import UIKit
import Alamofire
import AlamofireImage

protocol DetailsViewControllerDelegate: class {
  func displayDetailsArtObject(_ viewModel: DisplayDetailsArtObject)
  func displayDetailsDataLoadError(error: Swift.Error)
}

class DetailsViewController: UIViewController, Storyboarded{
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var objectNumber: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var titleDescription: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  private var activityIndicator: UIActivityIndicatorView?
  var viewModel: DetailsListViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getInitialData()
  }
  
  func getInitialData() {
    // show activity indicator
    activityIndicator = UIActivityIndicatorView(style: .large)
    view.addSubview(activityIndicator!)
    activityIndicator?.frame = view.bounds
    activityIndicator?.startAnimating()
    
    // get initial data
    viewModel?.loadDetailsData()
  }
}

// MARK: - CollectionViewControllerProtocol
extension DetailsViewController: DetailsViewControllerDelegate {
  func displayDetailsArtObject(_ viewModel: DisplayDetailsArtObject) {
    // hide activity indicator
    activityIndicator?.removeFromSuperview()
    
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    titleDescription.text = viewModel.titleDescription
    
    objectNumber.text = viewModel.identification.objectNumber
    descriptionLabel.text = viewModel.identification.description
    
    AF.request(viewModel.imageUrl).responseImage { response in
      if case .success(let image) = response.result {
        DispatchQueue.main.async { [weak self] in
          self?.imageView.image = image
        }
      }
    }
  }
  
  func displayDetailsDataLoadError(error: Swift.Error) {
    let alert = UIAlertController(title: "Alert", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    // here you can show user Alert Box about error
    print("Error: \(error)")
  }
}
