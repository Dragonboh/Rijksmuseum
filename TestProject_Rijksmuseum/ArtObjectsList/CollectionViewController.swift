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
  func displayArtObjects(_ viewModel: [DisplayArtObject])
  func displayDataLoadError(error: Swift.Error)
}

class MuseumCollectionViewController: UICollectionViewController, Storyboarded  {
  private var activityIndicator: UIActivityIndicatorView?
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  private let itemsPerRow: CGFloat = 2
  
  private let reuseIdentifier = "ArtObjectCell"
  private var artObjects = [DisplayArtObject]()
  private var currentPage = 0
  
  var viewModel: ArtObjectsListViewModelProtocol?
  
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
    viewModel?.loadData(page: currentPage)
  }
  
  func getNextPageData() {
    currentPage += 1
    
    // get data
    viewModel?.loadData(page: currentPage)
  }
  
  // MARK: UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    artObjects.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArtObjectCell
    
    if indexPath.row == artObjects.count / 2 {
      getNextPageData()
    }
    
    cell.title.text = artObjects[indexPath.row].title
    AF.request(artObjects[indexPath.row].url).responseImage { response in
      //print(response)
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
  
  func displayArtObjects(_ viewModel: [DisplayArtObject]) {
    activityIndicator?.removeFromSuperview()
    let currentRow = artObjects.count
    artObjects.append(contentsOf: viewModel)
    if currentPage == 0 {
      collectionView?.reloadData()
    } else {
      collectionView.performBatchUpdates({ () -> Void in
        var temp = [IndexPath]()
        
        for index in 0...(viewModel.count - 1) {
          temp.append(IndexPath(row: currentRow + index, section: 0))
        }
        collectionView.insertItems(at: temp)
        
      }, completion: nil)
    }
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
