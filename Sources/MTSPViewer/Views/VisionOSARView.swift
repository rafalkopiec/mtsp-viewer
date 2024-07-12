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

    @State private var entity: Entity?
    @Environment(\.physicalMetrics) private var physicalMetrics
    @State private var initialScale: Float?

    var body: some View {
        GeometryReader3D { geo in
            RealityView { content in
                if let entity = try? await Entity(contentsOf: modelURL) {
                    self.entity = entity
                    entity.generateCollisionShapes(recursive: true)
                    if initialScale == nil {
                        initialScale = entity.scale.max()
                    }
                    content.add(entity)
                    scale(in: content, with: geo)
                }
            } update: { content in
                scale(in: content, with: geo)
            }
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    onTap(value.entity)
                }
        )
        .padding()
    }

    private func scale(in content: RealityViewContent, with geo: GeometryProxy3D) {
        guard let entity else { return }
        let size = content.convert(boundingBox: entity.visualBounds(relativeTo: nil), from: .scene, to: .local)
        let viewSize = geo.size

        let maxR = min(viewSize.width/2, viewSize.height/2)
        let currentR = max(size.max.x/2, size.max.y/2)
        if maxR.isNormal, maxR > 0, currentR.isNormal, currentR > 0, let initialScale {
            let scale = Float(maxR/currentR) * initialScale
            entity.setScale(.init(repeating: scale), relativeTo: nil)
            let height = entity.visualBounds(relativeTo: nil).boundingRadius/2
            if height.isNormal, height > 0 {
                entity.transform.translation.y = -height
            }
        }
    }
}
#endif
