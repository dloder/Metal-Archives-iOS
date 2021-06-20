//
//  Theme.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 20/06/2021.
//

import SwiftUI

enum Theme: Int, CaseIterable {
    case `default` = 0, green/*, red, blue, orange, purple, yellow*/

    func primaryColor(for scheme: ColorScheme) -> Color {
        switch (scheme, self) {
        case (.light, .default):
            return Color(.sRGB, red: 114 / 255, green: 77 / 255, blue: 72 / 255, opacity: 1)
        case (.dark, .default):
            return Color(.sRGB, red: 140 / 255, green: 94 / 255, blue: 88 / 255, opacity: 1)
        case (.light, .green):
            return Color(.sRGB, red: 32 / 255, green: 139 / 255, blue: 58 / 255, opacity: 1)
        case (.dark, .green):
            return Color(.sRGB, red: 45 / 255, green: 198 / 255, blue: 83 / 255, opacity: 1)
        default: return .blue
        }
    }

    func secondaryColor(for scheme: ColorScheme) -> Color {
        switch (scheme, self) {
        case (.light, .default):
            return Color(.sRGB, red: 175 / 255, green: 135 / 255, blue: 120 / 255, opacity: 1)
        case (.dark, .default):
            return Color(.sRGB, red: 211 / 255, green: 171 / 255, blue: 158 / 255, opacity: 1)
        case (.light, .green):
            return Color(.sRGB, red: 74 / 255, green: 214 / 255, blue: 109 / 255, opacity: 1)
        case (.dark, .green):
            return Color(.sRGB, red: 183 / 255, green: 239 / 255, blue: 197 / 255, opacity: 1)
        default: return .blue
        }
    }
}
