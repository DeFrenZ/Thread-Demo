//
//  Banner.swift
//  Thread Demo
//
//  Created by Davide De Franceschi on 17/10/2019.
//  Copyright © 2019 Logic Craft Ltd. All rights reserved.
//

import SwiftUI

public struct Banner <Label: View>: View {
	private var action: (() -> Void)?
	private var label: Label

	public init(
		action: (() -> Void)? = nil,
		@ViewBuilder label labelBuilder: @escaping () -> Label
	) {
		self.action = action
		self.label = labelBuilder()
	}

	public var body: some View {
		Button(action: { self.action?() }) {
			label
				.font(Font.callout.weight(.semibold))
				.foregroundColor(.white)
				.multilineTextAlignment(.center)
				.padding()
				.frame(maxWidth: .infinity, minHeight: 44)
		}
			.background(Color.orange.edgesIgnoringSafeArea(.all))
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
		Banner {
			Text("Error message")
		}
			.previewLayout(.sizeThatFits)
			.multiplePreviewEnvironments()
    }
}
