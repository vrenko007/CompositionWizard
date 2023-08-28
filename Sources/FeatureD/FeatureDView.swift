//
//  FeatureDView.swift
//
//
//  Created by Matic Vrenko on 23. 08. 23.
//

import ComposableArchitecture
import FormData
import SwiftUI

public struct FeatureDFeature: Reducer {
  public init () {}

  public struct State: Equatable {
    public init(formData: FormData) {
      self.formData = formData
    }

    var formData: FormData
  }

  public enum Action {
    case submit
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .submit:
        // TODO: Submit Data
        return .none
      }
    }
  }
}

public struct FeatureDView: View {
  let store: StoreOf<FeatureDFeature>

  public init(store: StoreOf<FeatureDFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store, observe: { $0.formData }) { viewStore in
      Form {
        Text("\(viewStore.firstName)")
        Text("\(viewStore.lastName)")
        Text("\(viewStore.height) cm")
        if(viewStore.sex != .female)
        {
          Text("\(viewStore.weight) kg")
        }

        Button("Submit") {
          viewStore.send(.submit)
        }
      }
    }
  }
}

#Preview {
  FeatureDView(store: Store(initialState: FeatureDFeature.State(formData: .init()), reducer: {
    FeatureDFeature()
  }))
}
