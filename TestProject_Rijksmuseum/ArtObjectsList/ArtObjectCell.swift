//
//  ArtObjectCell.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import UIKit

class ArtObjectCell: UICollectionViewCell {
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var title: UILabel!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    image.image = nil
    title.text = ""
  }
}
