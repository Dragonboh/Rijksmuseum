//
//  MuseumArtWork.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

struct MuseumArtObjects: Decodable {
  let artObjects: [MuseumArtObject]
}

struct MuseumArtObject: Decodable {
  let title: String
  let objectNumber: String
  let webImage: WebImage
}

struct WebImage: Decodable {
  let guid: String
  let width: Int
  let height: Int
  let url: String
}

struct ArtObject: Decodable {
  let artObject: ArtObjectDetails
}

struct ArtObjectDetails: Decodable {
  let longTitle: String
  let physicalMedium: String
  let subTitle: String
  let label: DetailsLabel
  let description: String
  let webImage: WebImage
  
  struct DetailsLabel: Decodable {
    let description: String
  }
}
