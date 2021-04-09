//
//  MuseumAPI.swift
//  TestProject_Rijksmuseum
//
//  Created by Bogdan Pankevych.
//

import Foundation

let apiKey = "0fiuZFh4"
let objectsPerPage = "100"

protocol NetworkServiceProtocol {
  func getArtObjects(page: Int, completion: @escaping (Result<MuseumArtObjects, Swift.Error>) -> Void)
  func getArtObjectDetails(objectNumber: String, completion: @escaping (Result<ArtObject, Swift.Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
  enum Error: Swift.Error {
    case unknownAPIResponse
    case unknownAPIRequest
    case generic
  }
  
  private func getArtWorkURL(page: Int) -> URL? {
    let URLString = "https://www.rijksmuseum.nl/api/en/collection?key=\(apiKey)&p=\(page)&ps=\(objectsPerPage)"
    return URL(string: URLString)
  }
  
  private func getArtObjectDetailsURL(objectNumber: String) -> URL? {
    let URLString = "https://www.rijksmuseum.nl/api/en/collection/\(objectNumber)?key=\(apiKey)"
    return URL(string: URLString)
  }
  
  func getArtObjects(page: Int, completion: @escaping (Result<MuseumArtObjects, Swift.Error>) -> Void) {
    guard let getURL = getArtWorkURL(page: page) else {
      completion(.failure(Error.unknownAPIRequest))
      return
    }
    
    URLSession.shared.dataTask(with: URLRequest(url: getURL)) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard
        (response as? HTTPURLResponse) != nil,
        let data = data
      else {
        completion(.failure(Error.unknownAPIResponse))
        return
      }
      
      do {
        //data = self.readLocalFile(forName: "offlineData")!
        let decoder = JSONDecoder()
        let artObjects = try decoder.decode(MuseumArtObjects.self, from: data)
        //print(artObjects)
        completion(.success(artObjects))
        return
      } catch {
        completion(.failure(error))
        return
      }
    }
    .resume()
  }
  
  func getArtObjectDetails(objectNumber: String, completion: @escaping (Result<ArtObject, Swift.Error>) -> Void) {
    guard let getURL = getArtObjectDetailsURL(objectNumber: objectNumber) else {
      completion(.failure(Error.unknownAPIRequest))
      return
    }
    
    URLSession.shared.dataTask(with: URLRequest(url: getURL)) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard
        (response as? HTTPURLResponse) != nil,
        let data = data
      else {
        completion(.failure(Error.unknownAPIResponse))
        return
      }
      
      do {
        //data = self.readLocalFile(forName: "offlineData")!
        let decoder = JSONDecoder()
        let artObjects = try decoder.decode(ArtObject.self, from: data)
        //print(artObjects)
        completion(.success(artObjects))
        return
      } catch {
        completion(.failure(error))
        return
      }
    }
    .resume()
  }
  
  private func readLocalFile(forName name: String) -> Data? {
    do {
      if let bundlePath = Bundle.main.path(forResource: name,
                                           ofType: "json"),
         let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
        return jsonData
      }
    } catch {
      print(error)
    }
    
    return nil
  }
}
