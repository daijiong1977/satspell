import SwiftUI

enum ImageResolver {
    static func uiImage(for filename: String?) -> UIImage? {
        guard let filename, !filename.isEmpty else { return nil }

        // 1) Documents override
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let url = docs?.appendingPathComponent(filename),
           let data = try? Data(contentsOf: url),
           let img = UIImage(data: data) {
            return img
        }

        // 2) Bundle folder reference (e.g., Images/*.jpg)
        if let url = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: AppConfig.bundledImagesFolderName),
           let data = try? Data(contentsOf: url),
           let img = UIImage(data: data) {
            return img
        }

        // 3) Bundle root
        if let url = Bundle.main.url(forResource: filename, withExtension: nil),
           let data = try? Data(contentsOf: url),
           let img = UIImage(data: data) {
            return img
        }

        return nil
    }
}
