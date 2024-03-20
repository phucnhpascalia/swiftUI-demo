//
//  ContentView.swift
//  demo
//
//  Created by Nguyen Viet Khoa on 19/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var dragOffset: CGSize = .zero
    @State private var isPlanetInfoShown = false
    @State private var selectedPlanet: Planet?

    let planets: [Planet] = [
        Planet(name: "This is Earth", imageName: "earth", position: CGPoint(x: 200, y: 300)),
        Planet(name: "This is Venus", imageName: "venus", position: CGPoint(x: 250, y: 400)),
        // Add more planets as needed
    ]
    
    let backgroundWidth: CGFloat = UIScreen.main.bounds.width * 3
    let backgroundHeight: CGFloat = UIScreen.main.bounds.height * 3
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let invertedOffset = CGSize(width: value.translation.width, height: value.translation.height)
                            dragOffset = invertedOffset
                        }
                )
            ForEach(planets, id: \.self) {planet in
                Image(planet.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .position(CGPoint(x: planet.position.x + dragOffset.width, y: planet.position.y + dragOffset.height))
                    .gesture(
                        TapGesture()
                            .onEnded {
                                selectedPlanet = planet
                                isPlanetInfoShown = true
                            }
                    )
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isPlanetInfoShown) {
            if let selectedPlanet = selectedPlanet {
                PlanetDetailView(planet: selectedPlanet)
            }
        }
    }
    func adjustedPosition(for position: CGPoint, with offset: CGSize) -> CGPoint {
            return CGPoint(x: position.x + offset.width, y: position.y + offset.height)
        }
}
struct Planet: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let position: CGPoint
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

    static func == (lhs: Planet, rhs: Planet) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PlanetDetailView: View {
    let planet: Planet

    var body: some View {
        VStack {
            Text(planet.name)
                .font(.title)
            // Add more details about the planet
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
