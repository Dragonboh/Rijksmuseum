//
//  DisplayDetailsModel.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

struct DisplayDetailsArtObject {
  let title: String
  let subtitle: String
  let titleDescription: String
  let imageUrl: String
  let identification: Identification
  
  struct Identification {
    let description: String
    let objectNumber: String
  }
}
