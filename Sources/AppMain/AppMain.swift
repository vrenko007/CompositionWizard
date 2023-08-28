//
//  ContentView.swift
//  ComposableWizard
//
//  Created by Matic Vrenko on 23. 08. 23.
//

import SwiftUI
import FeatureA
import ComposableArchitecture
import ComposableNavigationTools

public enum Composition {
  public static var root: some Scene {
    WindowGroup {
      NavigationRoot {
        FeatureAView(store: Store(initialState: FeatureAFeature.State(formData: .init()), reducer: {
          FeatureAFeature()
        }))
      }
    }
  }
}
