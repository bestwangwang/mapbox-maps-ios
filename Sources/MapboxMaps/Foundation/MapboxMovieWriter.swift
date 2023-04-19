import Foundation
import AVFoundation

class MapboxMovieWriter {
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    var writerInput: AVAssetWriterInput?
    var writer: AVAssetWriter?
    var cacheUrl: URL!
    var beginDate = Date()
    var isWritting = false

    init() {
        generateCacheURL("effect_video.mov")
    }

    func startWriting() {
        isWritting = true
        beginDate = Date()
        generateCacheURL("effect_video.mov")
        print("Start synthesizing video \n save path->\(String(describing: self.cacheUrl))")
    }
    
    func finishWriting(_ completionHandler: @escaping () -> Void) {
        guard writer?.status == .writing else { return }
        isWritting = false
        writerInput?.markAsFinished()
        writer?.finishWriting {
            self.releaseWriter()
            print("End The synthetic video \n save path->\(String(describing: self.cacheUrl))")
            completionHandler()
        }
    }
    
    func append(_ texture: MTLTexture) -> Bool {
        guard isWritting else {
            // Write is controlled within the program, but this is not necessary
            return false
        }
        if let pixelBuffer = texture.pixelBuffer {
            return append(pixelBuffer)
        }
        return false
    }
    
    func append(_ pixelBuffer: CVPixelBuffer) -> Bool {
        initializetWriterIfNotExistes(pixelBuffer.size)
        
        let timeInterval = abs(beginDate.timeIntervalSinceNow)
        let frameTime = CMTime(seconds: timeInterval, preferredTimescale: 1000000)
        print("Computing time：\(timeInterval) \n\(frameTime)")
        
        return self.append(pixelBuffer, frameTime: frameTime)
    }
    
    func append(_ pixelBuffer: CVPixelBuffer, frameTime: CMTime) -> Bool {
        guard isWritting else {
            // Write is controlled within the program, but this is not necessary
            return false
        }
        guard writer?.status == .writing else {
            print("Cannot write data in the current state")
            return false
        }
        
        guard let input = writerInput, let adaptor = pixelBufferAdaptor else {
            fatalError("An error occurred in the write program。。")
        }
        
        if input.isReadyForMoreMediaData {
            print("Adding time：\(frameTime)")
            return adaptor.append(pixelBuffer, withPresentationTime: frameTime)
        }
        return false
    }
    
    func releaseWriter() {
        self.pixelBufferAdaptor = nil
        self.writerInput = nil
        self.writer = nil
    }
    
    deinit {
        finishWriting {}
        releaseWriter()
    }
}

extension MapboxMovieWriter {
    
    func initializetWriterIfNotExistes(_ videoSize: CGSize) {
        let writerInput: AVAssetWriterInput
        
        if let input = self.writerInput {
            writerInput = input
        } else {
            writerInput = generateWriterInput(videoSize)
            self.writerInput = writerInput
        }
        
        if self.pixelBufferAdaptor == nil {
            self.pixelBufferAdaptor = generatePixelBufferAdaptor(writerInput)
        }
        
        if self.writer == nil {
            self.writer = generateAssertWriter(writerInput)
            self.writer?.startWriting()
            self.writer?.startSession(atSourceTime: .zero)
        }
    }
    
    func generateWriterInput(_ videoSize: CGSize) -> AVAssetWriterInput {
        let compressionSettings: [String : Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: videoSize.width,
            AVVideoHeightKey: videoSize.height,
            AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
        ]
        
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: compressionSettings)
        input.expectsMediaDataInRealTime = true
        return input
    }
    
    func generatePixelBufferAdaptor(_ writerInput: AVAssetWriterInput) -> AVAssetWriterInputPixelBufferAdaptor {
        let bufferAttributes = [
            kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA
        ]
        return AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: bufferAttributes)
    }
    
    func generateAssertWriter(_ writerInput: AVAssetWriterInput) -> AVAssetWriter {
        let writer = try! AVAssetWriter(outputURL: cacheUrl, fileType: .mov)
        if writer.canAdd(writerInput){ writer.add(writerInput) }
        return writer
    }
    
    private func generateCacheURL(_ filename: String) {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let url = urls.first else {
            fatalError("Cannot access document folder")
        }
        cacheUrl = url.appendingPathComponent(filename)
                
        if FileManager.default.fileExists(atPath: cacheUrl.path) {
            try? FileManager.default.removeItem(atPath: cacheUrl.path)
        }
    }
}


extension CVPixelBuffer {
    var size: CGSize {
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        return CGSize(width: width, height: height)
    }
}

extension MTLTexture {
    var toPixelBuffer: CVPixelBuffer? {
        let pixelBufferOut = UnsafeMutablePointer<CVPixelBuffer?>.allocate(capacity: 1)

        var keyCallBack = CFDictionaryKeyCallBacks()
        var valueCallBacks = CFDictionaryValueCallBacks()
        
        var empty: CFDictionary = CFDictionaryCreate(kCFAllocatorDefault, nil, nil, 0, &keyCallBack, &valueCallBacks)
        let attributes = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, &keyCallBack, &valueCallBacks)
        
        var iOSurfacePropertiesKey = kCVPixelBufferIOSurfacePropertiesKey
        CFDictionarySetValue(attributes, &iOSurfacePropertiesKey, &empty)
        
        let cvreturn = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, attributes, pixelBufferOut)
        assert(cvreturn == kCVReturnSuccess, "Erorr : Unable to create effect video buffer")
        
        let cvpixelBuffer = pixelBufferOut.pointee
        pixelBufferOut.deallocate()
        
        guard let pixelBuffer = cvpixelBuffer else { return nil }
        
        let pixelRegion = MTLRegionMake2D(0, 0, width, height)
        let pixelBytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.init(rawValue: 0))
        }
        
        guard let memoryPointer = CVPixelBufferGetBaseAddress(pixelBuffer) else { return nil }
        getBytes(memoryPointer, bytesPerRow: pixelBytesPerRow, from: pixelRegion, mipmapLevel: 0)
        
        return pixelBuffer
    }
    
    var pixelBuffer: CVPixelBuffer? {
        
        let bytesPerRow = width * 4
        let pixelRegion = MTLRegionMake2D(0, 0, width, height)
        
                
        let dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
        
        getBytes(dataPtr, bytesPerRow: bytesPerRow, from: pixelRegion, mipmapLevel: 0)
        
        let releaseCallback: CVPixelBufferReleaseBytesCallback = { (mutablePointer, pointer) in
            mutablePointer?.deallocate()
        }
    
        var pxBuffer: CVPixelBuffer?
        
        CVPixelBufferCreateWithBytes(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA,
            dataPtr,
            width * 4,
            releaseCallback,
            dataPtr,
            [kCVPixelBufferIOSurfacePropertiesKey: [:]] as CFDictionary,
            &pxBuffer
        )
                    
        return pxBuffer
    }
}

