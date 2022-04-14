//
//  Storable.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import Foundation

protocol Retrievable {
  func retrieveCodable<T: Codable>(with key: StorageKey) -> T?
}

protocol Storable {
  func storeCodable<T: Codable>(with key: StorageKey, value: T)
}

typealias LocalStoreProtocol = Retrievable & Storable
