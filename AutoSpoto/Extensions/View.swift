//
//  View.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-01-28.
//

import SwiftUI
import Introspect

extension View {
    func customButton(
        foregroundColor: Color = .white,
        backgroundColor: Color = .gray,
        pressedColor: Color = .accentColor
    ) -> some View {
        self.buttonStyle(
            CustomButtonStyle(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                pressedColor: pressedColor
            )
        )
    }

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }

    public func introspectSplitView(customize: @escaping (NSSplitView) -> ()) -> some View {
        return inject(AppKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.findAncestorOrAncestorChild(ofType: NSSplitView.self, from: viewHost)
            },
            customize: customize
        ))
    }

}
