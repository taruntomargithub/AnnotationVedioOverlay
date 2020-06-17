//
//  VideoEditor.swift
//  VideoAnnotationAssignment
//
//  Created by Tarun Tomar on 13/06/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//


import AVFoundation
import UIKit

typealias SaveHandler = ((Bool, String?) -> Void)

class VideoEditor {
    
    class func loadVideo(feed: inout Feed, anotationText: String, savedHandler: @escaping SaveHandler) {
        let fileURL = feed.url
        let composition = AVMutableComposition()
        let vidAsset = AVURLAsset(url: fileURL, options: nil)
        
        // get video track
        let vtrack =  vidAsset.tracks(withMediaType: AVMediaType.video)
        let videoTrack:AVAssetTrack = vtrack[0]
        _ = videoTrack.timeRange.duration
        let vid_timerange = CMTimeRangeMake(start: CMTime.zero, duration: vidAsset.duration)
        let compositionvideoTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())!
        
        do {
            _ = try compositionvideoTrack.insertTimeRange(vid_timerange, of: videoTrack, at: CMTime.zero)
        } catch {
            print("error")
        }
        
        compositionvideoTrack.preferredTransform = videoTrack.preferredTransform
        
        // create text Layer
        let size = videoTrack.naturalSize
        let titleLayer = CATextLayer()
        titleLayer.backgroundColor = UIColor.clear.cgColor
        titleLayer.string = anotationText
        titleLayer.font = UIFont(name: "Helvetica", size: 28)
        titleLayer.foregroundColor = UIColor.green.cgColor
        titleLayer.shadowOpacity = 0.5
        titleLayer.alignmentMode = CATextLayerAlignmentMode.center
        titleLayer.frame = CGRect(x: 0, y: 200, width: size.width, height: size.height / 6)
        
        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentlayer.addSublayer(videolayer)
        parentlayer.addSublayer(titleLayer)
        
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        layercomposition.renderSize = size
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)
        
        // instruction for watermark
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
        instruction.layerInstructions = NSArray(object: layerinstruction) as [AnyObject] as [AnyObject] as! [AVVideoCompositionLayerInstruction]
        layercomposition.instructions = NSArray(object: instruction) as [AnyObject] as [AnyObject] as! [AVVideoCompositionInstructionProtocol]
        
        //  create new file to receive data
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as String
        let movieFilePath = docsDir.appending("\(feed.id).mov")
        let movieDestinationUrl = URL(fileURLWithPath: movieFilePath)
        //remove existing file
        _ = try? FileManager().removeItem(at: movieDestinationUrl)
        
        // use AVAssetExportSession to export video
        guard let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality) else {return}
        assetExport.videoComposition = layercomposition
        assetExport.outputFileType = AVFileType.mov
        assetExport.outputURL = movieDestinationUrl
        assetExport.exportAsynchronously(completionHandler: {
            switch assetExport.status{
            case  AVAssetExportSessionStatus.failed:
                print("failed \(String(describing: assetExport.error))")
                savedHandler(false, nil)
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(String(describing: assetExport.error))")
                savedHandler(false, nil)
            case AVAssetExportSessionStatus.completed:
                print("Completed")
                savedHandler(true, movieFilePath)
            default:
                print("unknown")
            }
        })
    }
}
