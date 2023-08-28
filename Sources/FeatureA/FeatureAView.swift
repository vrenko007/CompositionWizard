//
//  FeatureAView.swift
//
//
//  Created by Matic Vrenko on 23. 08. 23.
//

import ComposableArchitecture
import ComposableNavigationTools
import FeatureB
import FeatureC
import FormData
import SwiftUI

public struct FeatureAFeature: Reducer {
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
      case featureB(FeatureBFeature.State)
      case featureC(FeatureCFeature.State)
    }

    public enum Action {
      case featureB(FeatureBFeature.Action)
      case featureC(FeatureCFeature.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: /State.featureB, action: /Action.featureB) {
        FeatureBFeature()
      }
      Scope(state: /State.featureC, action: /Action.featureC) {
        FeatureCFeature()
      }
    }
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .submit:
        switch state.formData.sex {
        case .male:
          state.destination = .featureB(FeatureBFeature.State(formData: state.formData))
        case .female:
          state.destination = .featureC(FeatureCFeature.State(formData: state.formData))
        case .none:
          state.destination = nil
        }
        return .none
      case .binding:
        return .none
      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
  }
}

public struct FeatureAView: View {
  let store: StoreOf<FeatureAFeature>

  public init(store: StoreOf<FeatureAFeature>) {
    self.store = store
  }

  struct ViewState: Equatable {
    @BindingViewState var firstName: String
    @BindingViewState var lastName: String
    @BindingViewState var sex: FormData.Sex
  }

  public var body: some View {
    WithViewStore(store, observe: \.view) { viewStore in
      Form {
        TextField("First Name", text: viewStore.$firstName)
        TextField("First Name", text: viewStore.$lastName)
        Picker("Sex", selection: viewStore.$sex) {
          Text("Male").tag(FormData.Sex.male)
          Text("Female").tag(FormData.Sex.female)
        }.pickerStyle(.segmented)

        Button("Submit") {
          viewStore.send(.submit)
        }
      }
      .navigationLink(
        store: store.scope(state: \.$destination, action: { .destination($0) }),
        state: /FeatureAFeature.Destination.State.featureB,
        action: FeatureAFeature.Destination.Action.featureB
      ) { store in
        FeatureBView(store: store)
      }
      .navigationLink(
        store: store.scope(state: \.$destination, action: { .destination($0) }),
        state: /FeatureAFeature.Destination.State.featureC,
        action: FeatureAFeature.Destination.Action.featureC
      ) { store in
        FeatureCView(store: store)
      }
    }
  }
}

extension BindingViewStore<FeatureAFeature.State> {
  var view: FeatureAView.ViewState {
    FeatureAView.ViewState(
      firstName: self.$formData.firstName,
      lastName: self.$formData.lastName,
      sex: self.$formData.sex
    )
  }
}

#Preview {
  NavigationRoot {
    FeatureAView(store: Store(initialState: FeatureAFeature.State(formData: .init()), reducer: {
      FeatureAFeature()
    }))
  }
}
