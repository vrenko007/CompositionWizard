//
//  NavigationRoot.swift
//  
//
//  Created by Matic Vrenko on 28. 08. 23.
//

import SwiftUI

public struct NavigationRoot<Content: View>: View {

  let content: () -> Content

  public init(
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content
  }

  public var body: some View {
    if #available(iOS 16, *) {
      NavigationStack(root: content)
    } else {
      NavigationView(content: content)
        .navigationViewStyle(.stack)
    }
  }
}

#Preview {
  NavigationRoot {
    Text("Hello World").navigationTitle("Test Title")
  }
}
