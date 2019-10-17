//
//  Banner.swift
//  Thread Demo
//
//  Created by Davide De Franceschi on 17/10/2019.
//  Copyright © 2019 Logic Craft Ltd. All rights reserved.
//

import SwiftUI

struct Banner <Label: View>: View {
	var action: (() -> Void)?
	var label: () -> Label

    var body: some View {
        Button(action: { self.action?() }) {
			label()
				.font(Font.callout.weight(.semibold))
				.foregroundColor(.white)
				.multilineTextAlignment(.center)
				.padding()
		}
			.frame(maxWidth: .infinity, minHeight: 44)
			.background(Color.orange)
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
		Banner {
			Text("Error message")
		}
			.previewLayout(.sizeThatFits)
			.multipleSizeCategories()
			.multipleColorSchemes()
    }
}
