//
//  FavoriteButton.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import SwiftUI

struct FavoriteButton: View {
  let action: () -> Void
  let isFavorite: Bool

  var body: some View {
    Button(
      action: action,
      label: { Image(systemName: isFavorite ? "star.fill" : "star") }
    )
    .frame(width: 32, height: 44)
  }
}

// MARK: - Previews

struct FavoriteButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FavoriteButton(
        action: {},
        isFavorite: true
      )
      .previewLayout(.sizeThatFits)
      FavoriteButton(
        action: {},
        isFavorite: false
      )
      .previewLayout(.sizeThatFits)
    }
  }
}
