//
//  ActivityIndicator.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  let style: UIActivityIndicatorView.Style
  let color: UIColor
  @Binding var isAnimating: Bool

  init(style: UIActivityIndicatorView.Style, color: UIColor = .black, isAnimating: Binding<Bool>) {
    self.style = style
    self.color = color
    _isAnimating = isAnimating
  }

  func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView(style: style)
    activityIndicator.color = color
    return activityIndicator
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
  }
}
