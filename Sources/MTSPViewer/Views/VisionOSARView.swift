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

#if os(visionOS)
internal struct VisionOSARView: View {
    private let modelURL: URL
    private let onTap: ((Entity) -> Void)

    init(modelURL: URL, onTap: @escaping (Entity) -> Void) {
        self.modelURL = modelURL
        self.onTap = onTap
    }

    var body: some View {
        RealityView { content in
            if let entity = try? await Entity(contentsOf: modelURL) {
                entity.generateCollisionShapes(recursive: true)
                content.add(entity)
            }
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    onTap(value.entity)
                }
        )
    }
}
#endif
