// Copyright 2024 Rafal Kopiec
// https://metaspace.rocks/mtsp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import RealityKit
import SwiftUI

/// Creates a `.usdz` viewer that responds to taps on entities.
/// Acts like a normal view on non-visionOS.
/// On visionOS, it's recommended to use it in an ImmersiveSpace,
/// however you are free to experiment otherwise.
///
/// > Warning: The `modelURL` needs to be a local, downloaded
/// > file URL, otherwise unexpected errors may occur.
///
/// - Parameters:
///     - modelURL: A local `.usdz` file.
public struct MTSPViewer: View {
    /// Creates a `.usdz` viewer that responds to taps on entities.
    /// Acts like a normal view on non-visionOS.
    /// On visionOS, it's recommended to use it in an ImmersiveSpace,
    /// however you are free to experiment otherwise.
    ///
    /// > Warning: The `modelURL` needs to be a local, downloaded
    /// > file URL, otherwise unexpected errors may occur.
    ///
    /// - Parameters:
    ///     - modelURL: A local `.usdz` file.
    public init(modelURL: URL) {
        self.modelURL = modelURL
    }

    public var body: some View {
        #if os(visionOS)
        VisionOSARView(modelURL: modelURL) { entity in
            onTap?(entity.name)
        }
        #else
        IOSARView(
            modelURL: modelURL,
            arEnabled: arEnabled,
            clearBackground: clearBackground
        ) { entity in
            onTap?(entity.name)
        }
        #endif
    }

    private let modelURL: URL
    private var arEnabled: Bool = false
    private var clearBackground: Bool = false
    private var onTap: ((String) -> Void)?
}

public extension MTSPViewer {
    /// Gives back the name of the `entity` that was tapped.
    ///
    /// ```
    /// MTPSViewer(_:)
    ///     .onTapEntity { value in 
    ///         print(value) // "entity_name"
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///     - closure: Gives back the name of the entity that is tapped by the user.
    ///
    /// - Returns: A modified `MTPSViewer`.
    func onTapEntity(_ handler: @escaping (String) -> Void) -> MTSPViewer {
        var view = self
        view.onTap = handler
        return view
    }

    /// Enables or disables AR mode.
    /// Default is `true`.
    ///
    /// ```
    /// MTPSViewer(_:)
    ///     .arEnabled()
    ///
    /// MTPSViewer(_:)
    ///     .arEnabled(false)
    /// ```
    ///
    /// > Information: This does nothing on `visionOS`.
    ///
    /// - Parameters:
    ///     - enabled: Toggle AR mode.
    ///
    /// - Returns: A modified `MTPSViewer`.
    func arEnabled(_ enabled: Bool = true) -> MTSPViewer {
        var view = self
        view.arEnabled = enabled
        return view
    }

    /// Enables or disables clear background mode.
    /// Default is `false`.
    ///
    /// ```
    /// MTPSViewer(_:)
    ///     .clearBackground()
    ///
    /// MTPSViewer(_:)
    ///     .clearBackground(false)
    /// ```
    ///
    /// > Information: This does nothing on `visionOS`.
    ///
    /// - Parameters:
    ///     - enabled: Toggle clear background.
    ///
    /// - Returns: A modified `MTPSViewer`.
    func clearBackground(_ enabled: Bool = true) -> MTSPViewer {
        var view = self
        view.clearBackground = enabled
        return view
    }
}
