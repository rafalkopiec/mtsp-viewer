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

#if !os(visionOS)
internal struct IOSARView: UIViewRepresentable {
    private let onTap: ((Entity) -> Void)
    private let modelURL: URL
    private let arEnabled: Bool
    private let clearBackground: Bool

    init(
        modelURL: URL,
        arEnabled: Bool,
        clearBackground: Bool,
        onTap: @escaping (Entity) -> Void
    ) {
        self.modelURL = modelURL
        self.onTap = onTap
        self.arEnabled = arEnabled
        self.clearBackground = clearBackground
    }

    func makeUIView(context: Context) -> MTPSARView {
        let arView = MTPSARView(frame: .zero)
        arView.onTap = onTap
        arView.setupTapGestures()
        arView.cameraMode = arEnabled ? .ar: .nonAR
        return arView
    }

    func updateUIView(_ arView: MTPSARView, context: Context) {
        for anchor in arView.scene.anchors {
            arView.scene.removeAnchor(anchor)
        }

        loadScene(arView)

        arView.backgroundColor = clearBackground ? .clear: .systemBackground
        arView.environment.background = clearBackground ? .color(.clear): .cameraFeed()
    }

    private func loadScene(_ arView: MTPSARView) {
        if let entity = try? Entity.load(contentsOf: modelURL) {
            entity.generateCollisionShapes(recursive: true)
            let anchor = AnchorEntity()
            anchor.addChild(entity)
            arView.scene.addAnchor(anchor)
        }
    }
}

internal class MTPSARView: ARView {
    var onTap: ((Entity) -> Void)?

    func setupTapGestures() {
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGest)
    }

    @objc private func tapped(_ gest: UITapGestureRecognizer) {
        let locationInView = gest.location(in: self)
        guard let entity = entity(at: locationInView) else { return }
        onTap?(entity.parent ?? entity)
    }
}
#endif
