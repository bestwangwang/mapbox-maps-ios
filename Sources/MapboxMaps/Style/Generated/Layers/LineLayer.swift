// This file is generated.
import Foundation

/// A stroked line.
///
/// - SeeAlso: [Mapbox Style Specification](https://www.mapbox.com/mapbox-gl-style-spec/#layers-line)
public struct LineLayer: Layer {

    // MARK: - Conformance to `Layer` protocol
    /// Unique layer name
    public var id: String

    /// Rendering type of this layer.
    public let type: LayerType

    /// An expression specifying conditions on source features.
    /// Only features that match the filter are displayed.
    public var filter: Expression?

    /// Name of a source description to be used for this layer.
    /// Required for all layer types except ``BackgroundLayer``, ``SkyLayer``, and ``LocationIndicatorLayer``.
    public var source: String?

    /// Layer to use from a vector tile source.
    ///
    /// Required for vector tile sources.
    /// Prohibited for all other source types, including GeoJSON sources.
    public var sourceLayer: String?
    
    /// The slot this layer is assigned to. If specified, and a slot with that name exists, it will be placed at that position in the layer order.
    public var slot: String?

    /// The minimum zoom level for the layer. At zoom levels less than the minzoom, the layer will be hidden.
    public var minZoom: Double?

    /// The maximum zoom level for the layer. At zoom levels equal to or greater than the maxzoom, the layer will be hidden.
    public var maxZoom: Double?

    /// Whether this layer is displayed.
    public var visibility: Value<Visibility>

    /// The display of line endings.
    public var lineCap: Value<LineCap>?

    /// The display of lines when joining.
    public var lineJoin: Value<LineJoin>?

    /// Used to automatically convert miter joins to bevel joins for sharp angles.
    public var lineMiterLimit: Value<Double>?

    /// Used to automatically convert round joins to miter joins for shallow angles.
    public var lineRoundLimit: Value<Double>?

    /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
    public var lineSortKey: Value<Double>?

    /// Blur applied to the line, in pixels.
    public var lineBlur: Value<Double>?

    /// Transition options for `lineBlur`.
    public var lineBlurTransition: StyleTransition?

    /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color.
    public var lineBorderColor: Value<StyleColor>?

    /// Transition options for `lineBorderColor`.
    public var lineBorderColorTransition: StyleTransition?

    /// The width of the line border. A value of zero means no border.
    public var lineBorderWidth: Value<Double>?

    /// Transition options for `lineBorderWidth`.
    public var lineBorderWidthTransition: StyleTransition?

    /// The color with which the line will be drawn.
    public var lineColor: Value<StyleColor>?

    /// Transition options for `lineColor`.
    public var lineColorTransition: StyleTransition?

    /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels.
    public var lineDasharray: Value<[Double]>?

    /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded.
    public var lineDepthOcclusionFactor: Value<Double>?

    /// Transition options for `lineDepthOcclusionFactor`.
    public var lineDepthOcclusionFactorTransition: StyleTransition?

    /// Controls the intensity of light emitted on the source features. This property works only with 3D light, i.e. when `lights` root property is defined.
    public var lineEmissiveStrength: Value<Double>?

    /// Transition options for `lineEmissiveStrength`.
    public var lineEmissiveStrengthTransition: StyleTransition?

    /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
    public var lineGapWidth: Value<Double>?

    /// Transition options for `lineGapWidth`.
    public var lineGapWidthTransition: StyleTransition?

    /// A gradient used to color a line feature at various distances along its length. Defined using a `step` or `interpolate` expression which outputs a color for each corresponding `line-progress` input value. `line-progress` is a percentage of the line feature's total length as measured on the webmercator projected coordinate plane (a `number` between `0` and `1`). Can only be used with GeoJSON sources that specify `"lineMetrics": true`.
    public var lineGradient: Value<StyleColor>?

    /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset.
    public var lineOffset: Value<Double>?

    /// Transition options for `lineOffset`.
    public var lineOffsetTransition: StyleTransition?

    /// The opacity at which the line will be drawn.
    public var lineOpacity: Value<Double>?

    /// Transition options for `lineOpacity`.
    public var lineOpacityTransition: StyleTransition?

    /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
    public var linePattern: Value<ResolvedImage>?

    /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
    public var lineTranslate: Value<[Double]>?

    /// Transition options for `lineTranslate`.
    public var lineTranslateTransition: StyleTransition?

    /// Controls the frame of reference for `line-translate`.
    public var lineTranslateAnchor: Value<LineTranslateAnchor>?

    /// The line part between [trim-start, trim-end] will be marked as transparent to make a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0].
    public var lineTrimOffset: Value<[Double]>?

    /// Stroke thickness.
    public var lineWidth: Value<Double>?

    /// Transition options for `lineWidth`.
    public var lineWidthTransition: StyleTransition?

    public init(id: String, source: String) {
        self.source = source
        self.id = id
        self.type = LayerType.line
        self.visibility = .constant(.visible)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(sourceLayer, forKey: .sourceLayer)
        try container.encodeIfPresent(slot, forKey: .slot)
        try container.encodeIfPresent(minZoom, forKey: .minZoom)
        try container.encodeIfPresent(maxZoom, forKey: .maxZoom)

        var paintContainer = container.nestedContainer(keyedBy: PaintCodingKeys.self, forKey: .paint)
        try paintContainer.encodeIfPresent(lineBlur, forKey: .lineBlur)
        try paintContainer.encodeIfPresent(lineBlurTransition, forKey: .lineBlurTransition)
        try paintContainer.encodeIfPresent(lineBorderColor, forKey: .lineBorderColor)
        try paintContainer.encodeIfPresent(lineBorderColorTransition, forKey: .lineBorderColorTransition)
        try paintContainer.encodeIfPresent(lineBorderWidth, forKey: .lineBorderWidth)
        try paintContainer.encodeIfPresent(lineBorderWidthTransition, forKey: .lineBorderWidthTransition)
        try paintContainer.encodeIfPresent(lineColor, forKey: .lineColor)
        try paintContainer.encodeIfPresent(lineColorTransition, forKey: .lineColorTransition)
        try paintContainer.encodeIfPresent(lineDasharray, forKey: .lineDasharray)
        try paintContainer.encodeIfPresent(lineDepthOcclusionFactor, forKey: .lineDepthOcclusionFactor)
        try paintContainer.encodeIfPresent(lineDepthOcclusionFactorTransition, forKey: .lineDepthOcclusionFactorTransition)
        try paintContainer.encodeIfPresent(lineEmissiveStrength, forKey: .lineEmissiveStrength)
        try paintContainer.encodeIfPresent(lineEmissiveStrengthTransition, forKey: .lineEmissiveStrengthTransition)
        try paintContainer.encodeIfPresent(lineGapWidth, forKey: .lineGapWidth)
        try paintContainer.encodeIfPresent(lineGapWidthTransition, forKey: .lineGapWidthTransition)
        try paintContainer.encodeIfPresent(lineGradient, forKey: .lineGradient)
        try paintContainer.encodeIfPresent(lineOffset, forKey: .lineOffset)
        try paintContainer.encodeIfPresent(lineOffsetTransition, forKey: .lineOffsetTransition)
        try paintContainer.encodeIfPresent(lineOpacity, forKey: .lineOpacity)
        try paintContainer.encodeIfPresent(lineOpacityTransition, forKey: .lineOpacityTransition)
        try paintContainer.encodeIfPresent(linePattern, forKey: .linePattern)
        try paintContainer.encodeIfPresent(lineTranslate, forKey: .lineTranslate)
        try paintContainer.encodeIfPresent(lineTranslateTransition, forKey: .lineTranslateTransition)
        try paintContainer.encodeIfPresent(lineTranslateAnchor, forKey: .lineTranslateAnchor)
        try paintContainer.encodeIfPresent(lineTrimOffset, forKey: .lineTrimOffset)
        try paintContainer.encodeIfPresent(lineWidth, forKey: .lineWidth)
        try paintContainer.encodeIfPresent(lineWidthTransition, forKey: .lineWidthTransition)

        var layoutContainer = container.nestedContainer(keyedBy: LayoutCodingKeys.self, forKey: .layout)
        try layoutContainer.encode(visibility, forKey: .visibility)
        try layoutContainer.encodeIfPresent(lineCap, forKey: .lineCap)
        try layoutContainer.encodeIfPresent(lineJoin, forKey: .lineJoin)
        try layoutContainer.encodeIfPresent(lineMiterLimit, forKey: .lineMiterLimit)
        try layoutContainer.encodeIfPresent(lineRoundLimit, forKey: .lineRoundLimit)
        try layoutContainer.encodeIfPresent(lineSortKey, forKey: .lineSortKey)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(LayerType.self, forKey: .type)
        filter = try container.decodeIfPresent(Expression.self, forKey: .filter)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        sourceLayer = try container.decodeIfPresent(String.self, forKey: .sourceLayer)
        slot = try container.decodeIfPresent(String.self, forKey: .slot)
        minZoom = try container.decodeIfPresent(Double.self, forKey: .minZoom)
        maxZoom = try container.decodeIfPresent(Double.self, forKey: .maxZoom)

        if let paintContainer = try? container.nestedContainer(keyedBy: PaintCodingKeys.self, forKey: .paint) {
            lineBlur = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .lineBlur)
            lineBlurTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineBlurTransition)
            lineBorderColor = try paintContainer.decodeIfPresent(Value<StyleColor>.self, forKey: .lineBorderColor)
            lineBorderColorTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineBorderColorTransition)
            lineBorderWidth = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .lineBorderWidth)
            lineBorderWidthTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineBorderWidthTransition)
            lineColor = try paintContainer.decodeIfPresent(Value<StyleColor>.self, forKey: .lineColor)
            lineColorTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineColorTransition)
            lineDasharray = try paintContainer.decodeIfPresent(Value<[Double]>.self, forKey: .lineDasharray)
            lineDepthOcclusionFactor = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .lineDepthOcclusionFactor)
            lineDepthOcclusionFactorTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineDepthOcclusionFactorTransition)
            lineEmissiveStrength = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .lineEmissiveStrength)
            lineEmissiveStrengthTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineEmissiveStrengthTransition)
            lineGapWidth = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .lineGapWidth)
            lineGapWidthTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineGapWidthTransition)
            lineGradient = try paintContainer.decodeIfPresent(Value<StyleColor>.self, forKey: .lineGradient)
            lineOffset = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .lineOffset)
            lineOffsetTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineOffsetTransition)
            lineOpacity = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .lineOpacity)
            lineOpacityTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineOpacityTransition)
            linePattern = try paintContainer.decodeIfPresent(Value<ResolvedImage>.self, forKey: .linePattern)
            lineTranslate = try paintContainer.decodeIfPresent(Value<[Double]>.self, forKey: .lineTranslate)
            lineTranslateTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineTranslateTransition)
            lineTranslateAnchor = try paintContainer.decodeIfPresent(Value<LineTranslateAnchor>.self, forKey: .lineTranslateAnchor)
            lineTrimOffset = try paintContainer.decodeIfPresent(Value<[Double]>.self, forKey: .lineTrimOffset)
            lineWidth = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .lineWidth)
            lineWidthTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .lineWidthTransition)
        }

        var visibilityEncoded: Value<Visibility>?
        if let layoutContainer = try? container.nestedContainer(keyedBy: LayoutCodingKeys.self, forKey: .layout) {
            visibilityEncoded = try layoutContainer.decodeIfPresent(Value<Visibility>.self, forKey: .visibility)
            lineCap = try layoutContainer.decodeIfPresent(Value<LineCap>.self, forKey: .lineCap)
            lineJoin = try layoutContainer.decodeIfPresent(Value<LineJoin>.self, forKey: .lineJoin)
            lineMiterLimit = try layoutContainer.decodeIfPresent(Value<Double>.self, forKey: .lineMiterLimit)
            lineRoundLimit = try layoutContainer.decodeIfPresent(Value<Double>.self, forKey: .lineRoundLimit)
            lineSortKey = try layoutContainer.decodeIfPresent(Value<Double>.self, forKey: .lineSortKey)
        }
        visibility = visibilityEncoded ?? .constant(.visible)
    }

    enum RootCodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case filter = "filter"
        case source = "source"
        case sourceLayer = "source-layer"
        case slot = "slot"
        case minZoom = "minzoom"
        case maxZoom = "maxzoom"
        case layout = "layout"
        case paint = "paint"
    }

    enum LayoutCodingKeys: String, CodingKey {
        case lineCap = "line-cap"
        case lineJoin = "line-join"
        case lineMiterLimit = "line-miter-limit"
        case lineRoundLimit = "line-round-limit"
        case lineSortKey = "line-sort-key"
        case visibility = "visibility"
    }

    enum PaintCodingKeys: String, CodingKey {
        case lineBlur = "line-blur"
        case lineBlurTransition = "line-blur-transition"
        case lineBorderColor = "line-border-color"
        case lineBorderColorTransition = "line-border-color-transition"
        case lineBorderWidth = "line-border-width"
        case lineBorderWidthTransition = "line-border-width-transition"
        case lineColor = "line-color"
        case lineColorTransition = "line-color-transition"
        case lineDasharray = "line-dasharray"
        case lineDepthOcclusionFactor = "line-depth-occlusion-factor"
        case lineDepthOcclusionFactorTransition = "line-depth-occlusion-factor-transition"
        case lineEmissiveStrength = "line-emissive-strength"
        case lineEmissiveStrengthTransition = "line-emissive-strength-transition"
        case lineGapWidth = "line-gap-width"
        case lineGapWidthTransition = "line-gap-width-transition"
        case lineGradient = "line-gradient"
        case lineOffset = "line-offset"
        case lineOffsetTransition = "line-offset-transition"
        case lineOpacity = "line-opacity"
        case lineOpacityTransition = "line-opacity-transition"
        case linePattern = "line-pattern"
        case lineTranslate = "line-translate"
        case lineTranslateTransition = "line-translate-transition"
        case lineTranslateAnchor = "line-translate-anchor"
        case lineTrimOffset = "line-trim-offset"
        case lineWidth = "line-width"
        case lineWidthTransition = "line-width-transition"
    }
}

// End of generated file.
