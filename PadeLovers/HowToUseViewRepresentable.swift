//
//  HowToUseViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/08.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct HowToUseView: View {
    var body: some View {
        ZStack(alignment: .top) {
            WebView(
                urlString: "https://therapeutic-houseboat-0eb.notion.site/0c619679f98f41ce96ff523b2439d126?pvs=4"
            )
            Text("PadeLovers")
                .font(.title)
                .bold()
                .foregroundStyle(Color.appSpecialRed)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    HowToUseView()
}
