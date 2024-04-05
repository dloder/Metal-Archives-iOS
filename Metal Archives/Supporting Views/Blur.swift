//
//  Blur.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 19/07/2021.
//

import SwiftUI

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context _: Context) -> UIVisualEffectView {
        .init(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
