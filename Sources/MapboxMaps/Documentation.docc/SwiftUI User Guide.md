# SwiftUI User Guide

Use Mapbox Maps in SwiftUI applications.

## Overview

Starting from version `11.0.0-beta.2` of MapboxMaps you can easily integrate Mapbox into your apps using the SwiftUI framework.

You can find working [SwiftUI examples](https://github.com/mapbox/mapbox-maps-ios/tree/main/Apps/Examples/Examples/SwiftUI%20Examples) in the [Examples](https://github.com/mapbox/mapbox-maps-ios/tree/main/Apps/Examples) application.

- Important: SwiftUI support is experimental, the API may change in future releases.

### Feature support

The SwiftUI ``Map-swift.struct`` is built on top of the existing ``MapView``, which brings the full power of Mapbox Maps SDK to the SwiftUI applications.

However, not every single API is exposed in SwiftUI, you can track the progress in the table below.

Feature | Status | Note
--- | --- | ---
Viewport | ✅
View Annotations | ✅
Layer Annotations | ✅ | `isDraggable`, `isSelected` are not supported
Annotations Clustering | ✅ |
View Annotations | ✅ | `associatedFeatureId` is not supported
Puck 2D/3D | ✅
Map Events | ✅
Gesture Configuration | ✅
Ornaments Configuration | ✅
Style API | 🚧
Custom Camera Animations | 🚧

### Getting started

To start using Mapbox Map in SwiftUI you need to import `SwiftUI` and  `MapboxMaps` with `@_spi(Experimental)`. This way you can try the new APIs that have experimental support.

```swift
import SwiftUI
@_spi(Experimental) import MapboxMaps
```

Then you can use ``Map-swift.struct`` to display map content.

```swift
struct ContentView: View {
    init() {
        MapboxOptions.accessToken = "pk..."
    }
    var body: some View {
        Map()
          .ignoresSafeArea()
    }
}
```

Please note, that you have to set the Mapbox Access Token at any time before using the ``Map-swift.struct``. You can do it either by setting `MapboxOptions.accessToken` or any option listed in <doc:Migrate-to-v11##25-Access-Token-and-Map-Options-management>.

## Tutorials

### Setting Map style

By default the map uses the new ``MapStyle/standard`` style which brings rich 3D visualization. But you can use ``Map-swift.struct/mapStyle(_:)`` to set any other style.

```swift
Map()
  .mapStyle(.streets) // Sets Mapbox Streets Style.
```

With the Standard style you can set the lightPresets of the style according to your application's `colorScheme`. Light presents are 4 time-of-day states (`dawn`, `day`, `dusk`, `night`) that set the lighting and shadows of the map to represent changes in daylight.

```swift
struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Map()
            .mapStyle(.standard(lightPreset: colorScheme == .light ? .day : .dusk))
    }
}
```

Also, you always can use your custom Mapbox Styles built with [Mapbox Studio](https://studio.mapbox.com/).

```swift
let customStyle = StyleURI(rawValue: "mapbox://...")
Map()
    .mapStyle(MapStyle(uri: customStyle))
```

Please consult the ``MapStyle`` documentation to find more information about style loading.

### Using Viewport to manage camera

``Viewport`` is a powerful abstraction that manages the camera in SwiftUI. It supports multiple modes, such as `camera`, `overview`, `followPuck`, and others.

For example, with ``Viewport/camera(center:anchor:zoom:bearing:pitch:)`` you can set the camera parameters directly to the map.

```swift
let london = CLLocationCoordinate2D(latitude: 51.5073219, longitude: -0.1276474)
// Sets camera centered to London
Map(initialViewport: .camera(center: london, zoom: 12, bearing: 0, pitch: 0)
```

The `initialViewport` in the example above means that viewport will be set only on map initialization. If the user drags the map, it won't be possible to set the viewport again. In contrast, the example below uses `@State` variable via two-way data binding. With this approach, the viewport can be set and re-set whenever necessary. The approach you should use depends on your particular use case. 

```swift
struct ContentView: View {
    // Initializes viewport state as styleDefault,
    // which will use the default camera for the current style.
    @State var viewport: Viewport = .styleDefault

    var body: some View {
        VStack {
            // Passes the viewport binding to the map.
            Map(viewport: $viewport)
            Button("Overview route") {
                // Sets the viewport to overview (fit) the route, or any other geometry.
                viewport = .overview(geometry: LineString(...))
            }
            Button("Locate the user") {
                // Sets viewport to follow the user location.
                viewport = .followPuck(zoom: 16, pitch: 60)
            }
        }
    }
}
```

When the user drags the map, the viewport always resets to ``Viewport/idle`` state. You can't read the actual current camera state from that viewport, but you can observe it via ``Map-swift.struct/onCameraChanged(action:)``.

- Important: It's not recommended to store the camera values received from ``Map-swift.struct/onCameraChanged(action:)`` in `@State` property. They come with high frequency, which may lead to unwanted `body` re-execution and high CPU consumption. It's better to store them in model, or throttle before setting them to @State.


### Viewport animations

The viewport changes can be animated using the ``withViewportAnimation(_:body:completion:)`` function.

```swift
struct ContentView: View {
    @State var viewport: Viewport = .styleDefault


    var body: some View {
        VStack {
            Map(viewport: $viewport)
            Button("Animate viewport") {
                // Changes viewport with default animation
                withViewportAnimation {
                    viewport = .followPuck
                }
            }
            Button("Animate viewport (ease-in)") {
                // Changes viewport with ease-in animation
                withViewportAnimation(.easeIn(duration: 1)) {
                    viewport = .followPuck
                }
            }
        }
    }
}
```

Please consult the ``ViewportAnimation`` documentation to learn more about supported animations.

- Important: It's recommended to use ``ViewportAnimation/default(maxDuration:)`` animation when transition to ``Viewport/followPuck(zoom:bearing:pitch:)`` state. With other animation types, there might be a jump when animation finishes. It may happen because they're designed to finish at the static target.


### Annotations

There are two kinds of annotations in Maps SDK - ``ViewAnnotation``s and Layer Annotations (a.k.a ``PointAnnotation``, ``CircleAnnotation``, etc).

#### View Annotations

View annotation allow you to display any SwiftUI view on top of the map. They give you endless possibility for customization, but may be less performant. Also, they are always displayed above all map content.


The example below displays multiple view annotations.

```swift
struct ContentView: View {
    struct Item {...}
    @state var items = [Item]()

    var body: some View {
        Map {
            // Displays a single view annotation
            ViewAnnotation(CLLocationCoordinate(...))
                Text("🚀")
                    .background(Circle().fill(.red))
            }

            // Displays multiple data-driven view annotations.
            ForEvery(items, id: \.id) { item in
                ViewAnnotation(item.coordinate) {
                    ItemContentView(item)
                }
            }
        }
    }
}
```

- Note: The ``ForEvery`` above is similar to `ForEach` in SwiftUI, but works with Map content.

#### Layer Annotations

Layer annotations are rendered natively in the map using layers. They can be placed in between map layers, support clustering (for ``PointAnnotation``s only) and are usually more performant.

The example below displays different types of layer annotations.

```swift
struct ContentView: View {
    struct Item {...}
    @state var items = [Item]()

    var body: some View {
        Map {
            /// Displays a polygon annotation
            let polygon = Polygon(...)
            PolygonAnnotation(polygon: polygon)
                .fillColor(StyleColor(.systemBlue))
                .fillOpacity(0.5)
                .fillOutlineColor(StyleColor(.black))
                .onTapGesture {
                    print("Polygon is tapped")
                }

            /// Displays a single point annotation
            PointAnnotation(...)

            /// Displays data-driven group of point annotations.
            PointAnnotationGroup(items, id: \.id) { item in
                PointAnnotation(coordinate: item.coordinate)
                    .image(.init(image: UIImage(named: "blue_marker_view")!, name: "blue-icon"))
                    .iconAnchor(.bottom)
            }
            .clusterOptions(ClusterOptions(...))
        }
    }
```

In example above you can see that `PointAnnotation` (and other types of layer annotations) can be placed alone, or by using an annotation group, such as ``PointAnnotationGroup``. 

The first method is a handy way to place only one annotation of its kind. The second is better for multiple annotations and gives more configuration options such as clustering, layer position, and more. Annotation groups also behave like ``ForEvery`` for layer annotations.

### Displaying user position

The Puck allows you to display the user position on the map. The puck can be 2D or 3D.

The example below displays the user position using 2D puck.

```swift
Map {
    Puck2D(bearing: .heading)
        .showsAccuracyRing(true)
}
```

The example below displays the user position using custom 3D model.

```swift
Map {
    let duck = Model(
        uri: URL(string: "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf")!,
        orientation: [0, 0, -90])
    Puck3D(model: duck, bearing: .heading)
}
```

- Note: If you add multiple pucks into one map, only the last one will be displayed.

### Direct access to the underlying map implementation.

If some API is not yet exposed in SwiftUI, you can use ``MapReader`` to access the underlying map implementation.

```swift
var body: some View {
    MapReader { proxy in
        Map()
            .onAppear {
                configureUnderlyingMap(proxy.map)
            }
    }
}
```

We welcome your feedback on this experimental SwiftUI support. If you have any questions or comments please open an [issue in the Mapbox Maps SDK repo](https://github.com/mapbox/mapbox-maps-ios/issues) and add the `SwiftUI` label. 
