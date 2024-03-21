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
  @State private var zoomScale: CGFloat = 1.0
  @State private var prevOffset: CGPoint = .zero

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
              dragOffset = value.translation
            }
            .onEnded { _ in
              prevOffset.x += dragOffset.width
              prevOffset.y += dragOffset.height
              dragOffset = .zero
            }
        )
        .gesture(
          MagnificationGesture()
            .onChanged { value in
              setZoomScale(zoomScale + (value - 1) * 0.1)
            }
        )
        .scaleEffect((zoomScale - 1) * 0.1 + 1)
        .animation(.easeInOut(duration: 0.5), value: zoomScale)
      ForEach(planets, id: \.self) { planet in
        Image(planet.imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 50, height: 50)
          .position(
            CGPoint(
              x: planet.position.x + dragOffset.width + prevOffset.x,
              y: planet.position.y + dragOffset.height + prevOffset.y
            )
          )
          .gesture(
            TapGesture()
              .onEnded {
                selectedPlanet = planet
                isPlanetInfoShown = true
              }
          )
          .scaleEffect(zoomScale)
          .animation(.easeInOut(duration: 0.5), value: zoomScale)
      }
      VStack {
        Text("Zoom scale: \(zoomScale)")
          .foregroundColor(.red)
          .background(Color.white)
        HStack {
          Text("-")
            .font(.largeTitle)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .onTapGesture {
              setZoomScale(zoomScale - 1)
            }
          Slider(value: $zoomScale, in: 1...5, step: 0.1)
            .frame(width: 200)
            .accessibilityAction {
              print("Zoom scale: \(zoomScale)")
            }
          Text("+")
            .font(.largeTitle)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .onTapGesture {
              setZoomScale(zoomScale + 1)
            }
        }
      }
      .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
    }
    .edgesIgnoringSafeArea(.all)
    .sheet(isPresented: Binding(get: {
        isPlanetInfoShown
    }, set: {
        isPlanetInfoShown = $0
    })) {
      if let selectedPlanet = selectedPlanet {
        PlanetDetailView(planet: selectedPlanet)
      }
    }
  }
  func adjustedPosition(for position: CGPoint, with offset: CGSize) -> CGPoint {
    return CGPoint(x: position.x + offset.width, y: position.y + offset.height)
  }

  func setZoomScale(_ scale: CGFloat) {
    zoomScale = max(min(scale, 5), 1)
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
