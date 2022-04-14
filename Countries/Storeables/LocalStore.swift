//
//  LocalStorage.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import Foundation

final class LocalStore: LocalStoreProtocol {
  
  // MARK: - Variables
  
  private let userDefaults: UserDefaults
  
  // MARK: - Init
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  // MARK: - Methods
  
  func retrieveCodable<T>(with key: StorageKey) -> T? where T : Decodable, T : Encodable {
    guard
        let data = userDefaults.object(forKey: key.rawValue) as? Data,
        let model = try? JSONDecoder().decode(T.self, from: data) else { return nil }
    return model
  }
  
  func storeCodable<T>(with key: StorageKey, value: T) where T : Decodable, T : Encodable {
    guard let data = try? JSONEncoder().encode(value) else { return }
    userDefaults.set(data, forKey: key.rawValue)
  }
  
}
