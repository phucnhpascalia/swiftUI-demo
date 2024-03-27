//
//  NavigatorBar.swift
//  demo
//
//  Created by tsha on 27/03/2024.
//

import SwiftUI

struct NavigatorBar: View {
    var body: some View {
        HStack {
            Button(
                action: {
                    // handle back button action
                },
                label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 10)
                })
            Spacer()
            Text("Navigator Bar")
                .font(.title)
                .bold()
            Spacer()
            Button(
                action: {
                    // handle search button action
                },
                label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 10)
                })
        }
        .position(x: UIScreen.main.bounds.width / 2, y: 100)
        .foregroundColor(.white)
    }
}

#Preview {
    NavigatorBar()
}
