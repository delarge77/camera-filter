import AVKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation

struct SampleBufferTransformer {
    private let context = CIContext()
    func transform(videoSampleBuffer: CMSampleBuffer) -> CMSampleBuffer {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer) else {
            print("failed to get pixel buffer")
            fatalError()
        }

        // Create a CIImage from the pixel buffer so we can apply a CIFilter to it
        let inputImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Invert color using CIFilter
        let filter = CIFilter.colorInvert()
        filter.inputImage = inputImage
        guard let outputImage = filter.outputImage else {
            print("failed to apply filter")
            fatalError()
        }
        
        // Render the inverted image to the pixel buffer using a CIContext
        self.context.render(outputImage, to: pixelBuffer)


        guard let result = try? pixelBuffer.mapToSampleBuffer(timestamp: videoSampleBuffer.presentationTimeStamp) else {
            fatalError()
        }

        return result
    }
}
