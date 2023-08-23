//
//  ContentView.swift
//  ComposableWizard
//
//  Created by Matic Vrenko on 23. 08. 23.
//

import SwiftUI
import FeatureA

public enum Composition {
  public static var root: some Scene {
    WindowGroup {
      FeatureAView()
    }
  }
}
