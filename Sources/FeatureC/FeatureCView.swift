//
//  FeatureCView.swift
//
//
//  Created by Matic Vrenko on 23. 08. 23.
//

import SwiftUI
import FeatureD
import FormData
import ComposableArchitecture
import ComposableNavigationTools

public struct FeatureCFeature: Reducer {
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
        state.destination = .featureD(FeatureDFeature.State(formData: state.formData))
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

public struct FeatureCView: View {
  let store: StoreOf<FeatureCFeature>

  public init(store: StoreOf<FeatureCFeature>) {
    self.store = store
  }

  struct ViewState: Equatable {
    @BindingViewState var height: Int
  }

  public var body: some View {
    WithViewStore(self.store, observe: \.view) { viewStore in
      Form {
        Text("Height in cm")
        Slider(value: .convert(from: viewStore.$height), in: 0...300, step: 1) {
          Text("Height in cm")
        } minimumValueLabel: {
          Text("0")
        } maximumValueLabel: {
          Text("300")
        }

        Text("\(viewStore.height) cm")

        Button("Submit") {
          viewStore.send(.submit)
        }
      }
      .navigationLink(
        store: store.scope(state: \.$destination, action: { .destination($0) }),
        state: /FeatureCFeature.Destination.State.featureD,
        action: FeatureCFeature.Destination.Action.featureD
      ) { store in
        FeatureDView(store: store)
      }
    }
  }
}

extension BindingViewStore<FeatureCFeature.State> {
  var view: FeatureCView.ViewState {
    FeatureCView.ViewState(
      height: self.$formData.height
    )
  }
}

public extension Binding {
  static func convert<TInt, TFloat>(from intBinding: Binding<TInt>) -> Binding<TFloat>
  where TInt: BinaryInteger, TFloat: BinaryFloatingPoint
  {
    Binding<TFloat> (
      get: { TFloat(intBinding.wrappedValue) },
      set: { intBinding.wrappedValue = TInt($0) }
    )
  }

  static func convert<TFloat, TInt>(from floatBinding: Binding<TFloat>) -> Binding<TInt>
  where TFloat: BinaryFloatingPoint, TInt: BinaryInteger
  {
    Binding<TInt> (
      get: { TInt(floatBinding.wrappedValue) },
      set: { floatBinding.wrappedValue = TFloat($0) }
    )
  }
}

#Preview {
  FeatureCView(store: Store(initialState: FeatureCFeature.State(formData: .init()), reducer: {
    FeatureCFeature()
  }))
}
