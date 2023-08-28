//
//  FormData.swift
//
//
//  Created by Matic Vrenko on 28. 08. 23.
//

import Foundation

public struct FormData: Equatable {
  public init() {}
  public enum Sex: Equatable, Hashable, Identifiable {
    public var id: Self { self }

    case male, female, none
  }

  public var firstName: String = ""
  public var lastName: String = ""
  public var sex: Sex = .none
  public var height: Int = 0
  public var weight: Int = 0
}
