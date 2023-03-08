//
//  ImagePicker.swift
//  ChatGPT
//
//  Created by peak on 2023/2/17.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectImageData: Data?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            defer {
                self.parent.isPresented.toggle()
            }
            
            // click cancel
            guard let provider = results.first?.itemProvider else {
                return
            }
            guard provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, error in
                if let error = error {
                    print("load image errro: \(error)")
                    return
                }
                if let uiImage = image as? UIImage {
                    Task { @MainActor in
                        self.parent.selectImageData = uiImage.pngData()
                    }
                }
            }
        }
    }
}

