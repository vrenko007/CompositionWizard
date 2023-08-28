//
//  FeatureBView.swift
//
//
//  Created by Matic Vrenko on 23. 08. 23.
//

import SwiftUI
import FeatureD
import FormData
import ComposableArchitecture
import ComposableNavigationTools

public struct FeatureBFeature: Reducer {
  public init () {}

  public struct State: Equatable {
    public init(destination: Destination.State? = nil, formData: FormData) {
      self.destination = destination
      self.formData = formData
    }

    @PresentationState var destination: Destination.State?
    @BindingState var formData: FormData

  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    case submit
  }

  public struct Destination: Reducer, Equatable {
    public enum State: Equatable {
      case featureD(FeatureDFeature.State)
    }

    public enum Action {
      case featureD(FeatureDFeature.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: /State.featureD, action: /Action.featureD) {
        FeatureDFeature()
      }
    }
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .submit:
        state.destination = .featureD(.init(formData: state.formData))
        return .none
      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
  }
}

public struct FeatureBView: View {
  let store: StoreOf<FeatureBFeature>

  public init(store: StoreOf<FeatureBFeature>) {
    self.store = store
  }

  struct ViewState: Equatable {
    @BindingViewState var height: Int
    @BindingViewState var weight: Int
  }

  public var body: some View {
    WithViewStore(self.store, observe: \.view) { viewStore in
      Form {
        TextField("Height in cm", value: viewStore.$height, formatter: NumberFormatter())
        TextField("Weight in kg", value: viewStore.$weight, formatter: NumberFormatter())

        Button("Submit") {
          viewStore.send(.submit)
        }
      }
      .navigationLink(
        store: store.scope(state: \.$destination, action: { .destination($0) }),
        state: /FeatureBFeature.Destination.State.featureD,
        action: FeatureBFeature.Destination.Action.featureD
      ) { store in
        FeatureDView(store: store)
      }
    }
  }
}

extension BindingViewStore<FeatureBFeature.State> {
  var view: FeatureBView.ViewState {
    FeatureBView.ViewState(
      height: self.$formData.height, weight: self.$formData.weight
    )
  }
}

#Preview {
  FeatureBView(store: Store(initialState: FeatureBFeature.State(formData: .init())) {
    FeatureBFeature()
  })
}
