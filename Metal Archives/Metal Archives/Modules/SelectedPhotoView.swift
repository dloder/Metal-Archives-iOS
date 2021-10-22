//
//  PhotoView.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 09/10/2021.
//

import SwiftUI

struct SelectedPhotoView: View {
    @EnvironmentObject private var preferences: Preferences
    @Environment(\.selectedPhoto) private var selectedPhoto
    @State private var showPhotoOnly = false
    @State private var scaleFactor: CGFloat = 1.0
    @State private var imageSize: CGSize = .zero
    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {
            let gestures =
                TapGesture(count: 1)
                .onEnded {
                    showPhotoOnly.toggle()
                }
                .simultaneously(
                    with: TapGesture(count: 2)
                        .onEnded {
                            if scaleFactor == 1.0 {
                                scaleFactor = 2.2
                            } else {
                                scaleFactor = 1.0
                                offset = .zero
                            }
                        }
                )
                .simultaneously(
                    with: MagnificationGesture()
                        .onChanged { value in
                            showPhotoOnly = true
                            scaleFactor = value.magnitude
                        }
                        .onEnded { _ in
                            scaleFactor = max(1, scaleFactor)
                        }
                )
                .simultaneously(
                    with: DragGesture()
                        .onChanged { value in
                            offset += value.translation
                        }
                        .onEnded { _ in
                            if scaleFactor == 1.0 {
                                offset = .zero
                            }
//                            else if offset.width > 0 {
//                                offset.width = 0
//                            } else if imageSize.width * scaleFactor - imageSize.width + offset.width < 0 {
//                                offset.width = -(imageSize.width * scaleFactor - imageSize.width)
//                            }
                        }
                )

            Color(.systemBackground)
                .ignoresSafeArea()
                .gesture(gestures)

            Image(uiImage: selectedPhoto.wrappedValue?.image ?? .add)
                .resizable()
                .scaledToFit()
                .scaleEffect(scaleFactor, anchor: .center)
                .animation(.default)
                .gesture(gestures)
                .offset(offset)
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) {
                    imageSize = $0
                }

            VStack {
                HStack {
                    Button(action: {
                        selectedPhoto.wrappedValue = nil
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(preferences.theme.primaryColor)
                            .padding()
                    })
                    .disabled(showPhotoOnly)
                    .padding(.leading, -12)

                    Spacer()
                }

                Spacer()

                Text(selectedPhoto.wrappedValue?.description ?? "")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .opacity(showPhotoOnly ? 0 : 1)
            .animation(Animation.linear(duration: 0.15))
        }
    }
}

struct SelectedPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPhotoView()
    }
}

private extension CGSize {
    static func += (lhs: inout Self, rhs: Self) {
        lhs = CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}
