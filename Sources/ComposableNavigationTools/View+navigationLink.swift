//
//  View+navigationLink.swift
//
//
//  Created by Matic Vrenko on 28. 08. 23.
//

import SwiftUI
import ComposableArchitecture

extension View {
  public func navigationLink<
    State, Action, DestinationState, DestinationAction, Destination: View
  >(
    store: Store<PresentationState<State>, PresentationAction<Action>>,
    state toDestinationState: @escaping (_ state: State) -> DestinationState?,
    action fromDestinationAction: @escaping (_ destinationAction: DestinationAction) -> Action,
    @ViewBuilder destination: @escaping (_ store: Store<DestinationState, DestinationAction>) -> Destination
  ) -> some View {
    self
      .background {
        if #available(iOS 16, *) {
          VStack {
            EmptyView()
          }
          .navigationDestination(store: store, state: toDestinationState, action: fromDestinationAction, destination: destination)
        } else {
          NavigationLinkStore(store, state: toDestinationState, action: fromDestinationAction, onTap: {}, destination: destination) {
            EmptyView()
          }
        }
      }
  }
}

