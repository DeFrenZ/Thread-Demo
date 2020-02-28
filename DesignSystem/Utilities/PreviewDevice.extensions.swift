import SwiftUI

extension PreviewDevice: Equatable {
	public static func == (lhs: PreviewDevice, rhs: PreviewDevice) -> Bool {
		lhs.rawValue == rhs.rawValue
	}
}

extension PreviewDevice: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
}

extension PreviewDevice {
	public static let mac: PreviewDevice = "Mac"
	public static let iPhone7: PreviewDevice = "iPhone 7"
	public static let iPhone7Plus: PreviewDevice = "iPhone 7 Plus"
	public static let iPhone8: PreviewDevice = "iPhone 8"
	public static let iPhone8Plus: PreviewDevice = "iPhone 8 Plus"
	public static let iPhoneSE: PreviewDevice = "iPhone SE"
	public static let iPhoneX: PreviewDevice = "iPhone X"
	public static let iPhoneXs: PreviewDevice = "iPhone Xs"
	public static let iPhoneXsMax: PreviewDevice = "iPhone Xs Max"
	public static let iPhoneXR: PreviewDevice = "iPhone Xʀ"
	public static let iPadMini4: PreviewDevice = "iPad mini 4"
	public static let iPadAir2: PreviewDevice = "iPad Air 2"
	public static let iPadPro_9_7i: PreviewDevice = "iPad Pro (9.7-inch)"
	public static let iPadPro_12_9i: PreviewDevice = "iPad Pro (12.9-inch)"
	public static let iPad_5g: PreviewDevice = "iPad (5th generation)"
	public static let iPadPro_12_9i_2g: PreviewDevice = "iPad Pro (12.9-inch) (2nd generation)"
	public static let iPadPro_10_5i: PreviewDevice = "iPad Pro (10.5-inch)"
	public static let iPad_6g: PreviewDevice = "iPad (6th generation)"
	public static let iPadPro_11i: PreviewDevice = "iPad Pro (11-inch)"
	public static let iPadPro_12_9i_3g: PreviewDevice = "iPad Pro (12.9-inch) (3rd generation)"
	public static let iPadMini_5g: PreviewDevice = "iPad mini (5th generation)"
	public static let iPadAir_3g: PreviewDevice = "iPad Air (3rd generation)"
	public static let appleTV: PreviewDevice = "Apple TV"
	public static let appleTV4K: PreviewDevice = "Apple TV 4K"
	public static let appleTV4K_1080p: PreviewDevice = "Apple TV 4K (at 1080p)"
	public static let appleWatchS2_38mm: PreviewDevice = "Apple Watch Series 2 - 38mm"
	public static let appleWatchS2_42mm: PreviewDevice = "Apple Watch Series 2 - 42mm"
	public static let appleWatchS3_38mm: PreviewDevice = "Apple Watch Series 3 - 38mm"
	public static let appleWatchS3_42mm: PreviewDevice = "Apple Watch Series 3 - 42mm"
	public static let appleWatchS4_40mm: PreviewDevice = "Apple Watch Series 4 - 40mm"
	public static let appleWatchS4_44mm: PreviewDevice = "Apple Watch Series 4 - 44mm"
}
