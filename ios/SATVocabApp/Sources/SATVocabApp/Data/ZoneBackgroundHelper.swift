import UIKit

enum ZoneBackgroundHelper {
    private static let imageNames = [
        "zone-enchanted-forest",
        "zone-cloud-kingdom",
        "zone-crystal-caverns",
        "zone-starlight-summit",
    ]

    static func image(forZoneIndex zoneIndex: Int) -> UIImage? {
        let name = imageNames[zoneIndex % imageNames.count]
        if let url = Bundle.main.url(forResource: name, withExtension: "png", subdirectory: "MapBackgrounds") {
            return UIImage(contentsOfFile: url.path)
        }
        if let url = Bundle.main.url(forResource: name, withExtension: "png") {
            return UIImage(contentsOfFile: url.path)
        }
        return nil
    }
}
