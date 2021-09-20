//
//  AnimationView+.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/15.
//

import Foundation
import Lottie

extension AnimationView {
  convenience init(
    asset name: String,
    bundle: Bundle = Bundle.main,
    imageProvider: AnimationImageProvider? = nil,
    animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache
  ) {
    let animation = Animation.asset(name, bundle: bundle, animationCache: animationCache)
    let provider = imageProvider ?? BundleImageProvider(bundle: bundle, searchPath: nil)
    self.init(animation: animation, imageProvider: provider)
  }
}
