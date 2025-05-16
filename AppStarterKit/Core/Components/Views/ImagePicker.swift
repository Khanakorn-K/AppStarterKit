//
//  ImagePicker.swift
//  FIrstFullSwiftUI
//
//  Created by Chanchana Koedtho on 18/10/2566 BE.
//

import Foundation
import SwiftUI
import PhotosUI
import AVKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedImage: [UIImage]
    @Binding var selectedVideoURls: [URL]
    
    let sourceType: UIImagePickerController.SourceType
    let selectionLimit: Int
    let captureMode: UIImagePickerController.CameraCaptureMode
    
    var completionHandler: (()->())?
    
    init(sourceType: UIImagePickerController.SourceType = .photoLibrary,
         selectedImage: Binding<[UIImage]> = .constant([]),
         selectedVideoURls: Binding<[URL]> = .constant([]),
         selectionLimit: Int = 1,
         captureMode: UIImagePickerController.CameraCaptureMode = .photo,
         completionHandler: (() -> ())? = nil) {
        self.sourceType = sourceType
        self._selectedImage = selectedImage
        self.selectionLimit = selectionLimit
        self.completionHandler = completionHandler
        self.captureMode = captureMode
        self._selectedVideoURls = selectedVideoURls
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIViewController {
        if sourceType == .camera || captureMode == .video {
            // Create View Controlelr
            let imagePicker = UIImagePickerController()
            
            // Configuration
            imagePicker.allowsEditing = captureMode == .video
            imagePicker.sourceType = sourceType
            
            if captureMode == .video {
                imagePicker.mediaTypes = [UTType.movie.identifier]
            }
            
            if sourceType == .camera {
                imagePicker.cameraCaptureMode = captureMode
            }
            
            imagePicker.videoExportPreset = AVAssetExportPresetPassthrough
            
            imagePicker.delegate = context.coordinator
            
            return imagePicker
        } else {
            // Configuration
            var configuration = PHPickerConfiguration()
            configuration.filter = captureMode == .photo ? .images : .videos
            configuration.selectionLimit = selectionLimit
            
            // Create View Controlelr
            let imagePicker = PHPickerViewController(configuration: configuration)
            imagePicker.delegate = context.coordinator
            
            return imagePicker
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension ImagePicker {
    final class Coordinator: NSObject {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

    }
}

extension ImagePicker.Coordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            parent.selectedImage = [image]
        } else if let vdoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            parent.selectedVideoURls = [vdoURL]
        }

        parent.dismiss()
        parent.completionHandler?()
    }
}

extension ImagePicker.Coordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if parent.captureMode == .photo {
            handleLoadImage(results: results)
        } else {
            handleLoadVideo(results: results)
        }
       
    }
    
    private func handleLoadImage(results: [PHPickerResult]) {
        let imageItems = results
            .map{ $0.itemProvider }
            .filter{ $0.canLoadObject(ofClass: UIImage.self) }
            .enumerated()
            .map{ PickedImageItem(index: $0, provider: $1) }
        
        let dispatchGround = DispatchGroup()
        var rawLoadImage = [PickedImageItem]()
        
        imageItems.forEach{ item in
            dispatchGround.enter()
            
            item.provider.loadObject(ofClass: UIImage.self,
                          completionHandler: { image, _ in
                if let image = image as? UIImage {
                    var copy = item
                    copy.image = image
                    rawLoadImage.append(copy)
                }
                
                dispatchGround.leave()
            })
        }
        
        dispatchGround.notify(queue: .main,
                              execute: { [weak self] in
            self?.parent.selectedImage = rawLoadImage.sorted(by: { $0.index < $1.index }).compactMap{ $0.image }
            self?.parent.completionHandler?()
        })
    }
    
    private func handleLoadVideo(results: [PHPickerResult]) {
        let movie = UTType.movie.identifier
        let dispatchGroup = DispatchGroup()
        let videoItems = results
            .map{ $0.itemProvider }
            .filter{ $0.hasItemConformingToTypeIdentifier(movie) }
            .enumerated()
            .map{ PickedVideoItem(index: $0, provider: $1) }
        var urlRawList = [PickedVideoItem]()
        
        videoItems.forEach{ item in
            dispatchGroup.enter()
            
            item.provider.loadFileRepresentation(forTypeIdentifier: movie,
                                                 completionHandler: { url, error in
                
                if let url = url {
                    
//                    self.copyFileToTemporaryDirectory(at: url) { copyPath in
//                        var copy = item
//                        copy.url = copyPath
//                        urlRawList.append(copy)
//                        
//                        dispatchGroup.leave()
//                    }
                    DispatchQueue.main.sync {
                        
                        var copy = item
                        copy.url = url
                        urlRawList.append(copy)
                        
                        dispatchGroup.leave()
                    }
                }
            })
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            self?.parent.selectedVideoURls = urlRawList.sorted(by: { $0.index < $1.index }).compactMap{ $0.url }
            self?.parent.completionHandler?()
        })
    }
    
    private func copyFileToTemporaryDirectory(at sourceURL: URL, completion: @escaping (URL?) -> Void) {
        DispatchQueue.main.sync {
            do {
                let temporaryDirectory = FileManager.default.temporaryDirectory
                let destinationURL = temporaryDirectory.appendingPathComponent("tempVdo.\(sourceURL.pathExtension)")
                // If file exists at destination, remove it
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }
                
                try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                // Now the file is copied to the app's document directory
                DispatchQueue.main.async {
                    completion(destinationURL)
                }
            } catch {
                print("Error copying file: \(error)")
            }
        }
    }
}

protocol PickedItem {
    var index: Int { get }
    var provider: NSItemProvider { get }
}

private struct PickedImageItem: PickedItem{
    var index: Int
    var provider: NSItemProvider
    var image: UIImage?
}

private struct PickedVideoItem: PickedItem{
    var index: Int
    var provider: NSItemProvider
    var url: URL?
}
