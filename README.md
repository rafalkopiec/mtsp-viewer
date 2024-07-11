## mtsp-viewer
This is a RealityKit-based Swift viewer for `.usdz` files, which are what the `.mtsp` container is built around.
For more information on `.mtsp`, visit [github.com/rafalkopiec/mtsp](https://github.com/rafalkopiec/mtsp).

### Usage:
- Add `MTSPViewer` as a Swift Package Manager dependency `https://github.com/rafalkopiec/mtsp-viewer.git`.
- Add the `MTSPViewer` view to your SwiftUI view hierarchy:
  - For iOS, iPadOS and macOS apps, this works like a regular View.
  - For visionOS, it's recommended to use this in an ImmersiveSpace, however it can also work in a regular view hierarchy if you're brave.
- When the user taps on an `Entity`, you will get back the name of the tapped `Entity` by using the `onTapEntity(_:)` view closure extension.

This component is designed to be used with `.usdz` scenes that have named entities - I've found good results by naming entities in [Reality Composer Pro](https://developer.apple.com/documentation/visionos/designing-realitykit-content-with-reality-composer-pro).

By design, the names given back would ideally be unique (provided by the `.usdz` scene), and as such would allow you to program actions based on taps on entities.
Through `.mtsp` principles, the `.mtsp` file (`v1.1.0+`) has links corresponding to entity names - much akin to HyperText in HTML.
