//
//  MuseumCollectionViewController.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import UIKit
import Alamofire
import AlamofireImage

protocol CollectionViewControllerProtocol: class {
  func displayInitialArtObjects(_ viewModel: [DisplayArtObject])
  func displayNextArtObjects(_ viewModel: [DisplayArtObject])
  func displayDataLoadError(error: Swift.Error)
}

class MuseumCollectionViewController: UICollectionViewController, Storyboarded  {
  private var activityIndicator: UIActivityIndicatorView?
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  private let itemsPerRow: CGFloat = 2
  
  private let reuseIdentifier = "ArtObjectCell"
  private var artObjects = [DisplayArtObject]()
  var viewModel: ListViewModelProtocol?
  
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
    
    // get data
    viewModel?.loadData()
  }
  
  func getNextPageData() {
    // get data
    viewModel?.loadNextPageData()
  }
  
  // MARK: UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    artObjects.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArtObjectCell
    
    if indexPath.row == artObjects.count - 50 {
      getNextPageData()
    }
    
    cell.title.text = artObjects[indexPath.row].title
    AF.request(artObjects[indexPath.row].url).responseImage { response in
      if case .success(let image) = response.result {
        DispatchQueue.main.async {
          cell.image.image = image
        }
      }
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel?.showArtObjectDetails(index: indexPath.row)
  }
}

// MARK: - CollectionViewControllerProtocol
extension MuseumCollectionViewController: CollectionViewControllerProtocol {
  func displayDataLoadError(error: Swift.Error) {
    activityIndicator?.removeFromSuperview()
    
    // here you can show user Alert about error
    print("Error: \(error)")
  }
  
  func displayInitialArtObjects(_ viewModel: [DisplayArtObject]) {
    activityIndicator?.removeFromSuperview()
    artObjects.append(contentsOf: viewModel)
    collectionView?.reloadData()
  }
  
  func displayNextArtObjects(_ viewModel: [DisplayArtObject]) {
    activityIndicator?.removeFromSuperview()
    let currentRow = artObjects.count
    artObjects.append(contentsOf: viewModel)
    collectionView.performBatchUpdates({ () -> Void in
      var newIndexPaths = [IndexPath]()
      
      for index in 0...(viewModel.count - 1) {
        newIndexPaths.append(IndexPath(row: currentRow + index, section: 0))
      }
      collectionView.insertItems(at: newIndexPaths)
    }, completion: nil)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MuseumCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
