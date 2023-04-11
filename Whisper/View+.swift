//
//  View+.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/10.
//

import SwiftUI

extension View {
    var toAnyView: AnyView {
        AnyView(self)
    }

//    @ViewBuilder
//    func alert(with data: AlertData,
//               isPresented: Binding<Bool>) -> some View {
//        switch data.type {
//            case .alert:
//                self.alert(data.title, isPresented: isPresented) {
//                    ForEach(data.actions.indices, id: \.self) {
//                        data.actions[$0]
//                    }
//                } message: {
//                    data.description.map(Text.init)
//                }
//
//            case .confirmation:
//                self.confirmationDialog(data.title, isPresented: isPresented) {
//                    ForEach(data.actions.indices, id: \.self) {
//                        data.actions[$0]
//                    }
//                } message: {
//                    data.description.map(Text.init)
//                }
//        }
//    }

    func execute(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }

    func toggleAlwaysBounce(_ axis: Axis.Set) -> some View {
        modifier(AlwaysBounceModifier(axis: axis))
    }

//    func screenLog(name: String) -> some View {
//        cdpScreen(name: name, class: "View")
//    }
//
//    func screenLog<T>(_: T) -> some View where T: View {
//        cdpScreen(name: String(describing: T.self).mapIf {
//            $0.hasSuffix("View")
//        } then: { $0.dropLast(4).lowercased() },
//                  class: String(describing: T.self))
//    }

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    func clearView(block: () -> Void) -> some View {
        block()
        return Color.clear
    }

//    @ViewBuilder
//    func skeleton(on: Bool) -> some View {
//        if on {
//            modifier(SkeletonModifier())
//        }
//    }

    func overlayBlur(opacity: Double = 0.5) -> some View {
        modifier(OverlayBlurModifier(opacity: opacity))
    }

    func toggleAnimation(bindValue: Bool,
                         completion: @escaping () -> Void) -> some View {
        modifier(ToggleAnimatableModifier(bindValue: bindValue,
                                          completion: completion))
    }
}

extension View {
    // This function changes our View to UIView, then calls another function
    // to convert the newly-made UIView to a UIImage.
    public var asUIImage: UIImage {
        let controller = UIHostingController(rootView: self)

        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.activeWindow?.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage
        controller.view.removeFromSuperview()
        return image
    }
}
//fileprivate struct SkeletonModifier: ViewModifier {
//    static let screenSize = UIScreen.main.bounds.size
//
//    @State private var startPoint: UnitPoint = .init(x: -2, y: 0)
//    @State private var endPoint: UnitPoint = .init(x: 1, y:0)
//    @State private var gradient: Gradient = .init(colors: [.gray4, .gray2, .gray4, .gray2,])
//
//    func body(content: Content) -> some View {
//        content
//            .onAppear {
//                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
//                    startPoint = .init(x: 0, y: 0)
//                    endPoint = .init(x: 3, y: 0)
//                }
//            }
//            .overlay {
//                GeometryReader { proxy in
//                    let global = proxy.frame(in: .global)
//                    LinearGradient(gradient: gradient,
//                                   startPoint: startPoint,
//                                   endPoint: endPoint)
//                    .offset(x: -global.origin.x)
//                    .frame(width: Self.screenSize.width)
//                }
//            }
//    }
//}

fileprivate struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let bezier = UIBezierPath(roundedRect: rect,
                                  byRoundingCorners: corners,
                                  cornerRadii: .init(width: radius, height: radius))
        return .init(bezier.cgPath)
    }
}

fileprivate struct AlwaysBounceModifier: ViewModifier {
    let axis: Axis.Set

    func body(content: Content) -> some View {
        content.onAppear {
            if axis.contains(.vertical) {
                UIScrollView.appearance().alwaysBounceVertical = false
            }
            if axis.contains(.horizontal) {
                UIScrollView.appearance().alwaysBounceHorizontal = false
            }
        }
        .onDisappear {
            if axis.contains(.vertical) {
                UIScrollView.appearance().alwaysBounceVertical = true
            }
            if axis.contains(.horizontal) {
                UIScrollView.appearance().alwaysBounceHorizontal = true
            }
        }
    }
}

//struct ScrollContentBackgroundModifier: ViewModifier {
//    let visibility: Visibility
//    func body(content: Content) -> some View {
//        if #available(iOS 16.0, *) {
//            content.scrollContentBackground(visibility)
//        }
//        else {
//            content
//        }
//    }
//}

//struct ScrollKeyboardDismissModeModifier: ViewModifier {
//    let dismissMode: UIScrollView.KeyboardDismissMode
//    func body(content: Content) -> some View {
//        if #available(iOS 16.0, *) {
//            content.scrollDismissesKeyboard(dismissMode.scrollDismissesKeyboardMode)
//        }
//        else {
//            content.execute { _ in
//                UIScrollView.appearance().keyboardDismissMode = dismissMode
//            }
//        }
//    }
//}
//
//@available(iOS 16.0, *)
//fileprivate extension UIScrollView.KeyboardDismissMode {
//    var scrollDismissesKeyboardMode: ScrollDismissesKeyboardMode {
//        switch self {
//            case .none:
//                return .never
//            case .onDrag:
//                return .immediately
//            case .interactive:
//                return .interactively
//            case .onDragWithAccessory:
//                return .immediately
//            case .interactiveWithAccessory:
//                return .interactively
//            @unknown default:
//                return .never
//        }
//    }
//}

//struct SrollDisabledModifier: ViewModifier {
//    let disable: Bool
//    func body(content: Content) -> some View {
//        if #available(iOS 16.0, *) {
//            content.scrollDisabled(disable)
//        }
//        else {
//            content
//        }
//    }
//}

fileprivate struct OverlayBlurModifier: ViewModifier {
    let opacity: Double

    func body(content: Content) -> some View {
        ZStack {
            content
            Color.black.opacity(opacity)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial.opacity(0.8))

        }
    }
}

fileprivate struct ToggleAnimatableModifier: AnimatableModifier {
    var targetValue: Double

    var animatableData: Double {
        didSet {
            checkIfFinished()
        }
    }

    var completion: () -> Void

    func checkIfFinished() {
        if targetValue == animatableData {
            Task { @MainActor in
                self.completion()
            }
        }
    }

    init(bindValue: Bool,
         completion: @escaping () -> Void) {
        self.targetValue = bindValue ? 1 : 0
        self.animatableData = bindValue ? 1 : 0
        self.completion = completion
    }

    func body(content: Content) -> some View {
        content
    }
}

//struct DoubleAnimatableModifier: AnimatableModifier {
//    // SwiftUI gradually varies it from old value to the new value
//    var targetValue: Double = 0
//
//    var animatableData: Double {
//        didSet {
//            checkIfFinished()
//        }
//    }
//
//    var completion: () -> Void
//
//    func checkIfFinished() {
//        if targetValue == animatableData {
//            DispatchQueue.main.async {
//                self.completion()
//            }
//        }
//    }
//
//    init(bindValue: Double,
//         completion: @escaping () -> ()) {
//        self.targetValue = bindValue
//        self.animatableData = bindValue
//        self.completion = completion
//    }
//
//    func body(content: Content) -> some View {
//        content
//    }
//}
