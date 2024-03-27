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
    @State private var planetPositions: [CGPoint] = []
    @State private var planets: [Planet] = []

    let backgroundWidth: CGFloat = UIScreen.main.bounds.width * 2
    let backgroundHeight: CGFloat = UIScreen.main.bounds.height * 1
    let numberOfPlanets = 100
    let gridSize: CGFloat = 60
    let planetSizes: [CGSize] = [
        CGSize(width: 40, height: 40),
        CGSize(width: 30, height: 30),
        CGSize(width: 20, height: 20),
        CGSize(width: 10, height: 10)
    ]

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
                        .frame(width: planet.size.width, height: planet.size.height)
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
                HStack {
                    Button(action: {
                        setZoomScale(zoomScale - 1)
                    }) {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                    Slider(value: $zoomScale, in: 1...5, step: 0.1)
                        .frame(width: 150)
                        .accessibilityAction {
                            print("Zoom scale: \(zoomScale)")
                        }
                    Button(action: {
                        setZoomScale(zoomScale + 1)
                    }) {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                }
                .padding([.leading, .trailing], 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 60)
                        .stroke(Color.gray, lineWidth: 3)
                )
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
            if isPlanetInfoShown {
                CustomDialog(isActive: $isPlanetInfoShown, title: selectedPlanet?.name ?? "default", message: "haha", buttonTitle: "Save", action: {})
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            var map = createParkingMap()

            for _ in 0..<numberOfPlanets {
                let position = generateUniquePosition(map: &map)
                let randomSize = planetSizes.randomElement()!
                let point = CGPoint(
                    x: position[0] + generateNoise(value: randomSize.width),
                    y: position[1] + generateNoise(value: randomSize.height))

                planets.append(Planet(name: "This is Demo", imageName: ["post1","post2", "post3", "post4", "post5"].randomElement()!, position: point, size: randomSize))
            }
        }
    }
    func adjustedPosition(for position: CGPoint, with offset: CGSize) -> CGPoint {
      return CGPoint(x: position.x + offset.width, y: position.y + offset.height)
    }

    func setZoomScale(_ scale: CGFloat) {
        zoomScale = max(min(scale, 5), 1)
    }

    func generateNoise(value: CGFloat) -> Int {
        let diff = (gridSize - value) / 2
        return Int.random(in: -Int(diff)...Int(diff))
    }

    func generateUniquePosition(map: inout [Int]) -> [Int] {
        let slot = map.removeFirst()
        let totalCols = Int(backgroundWidth / gridSize)
        let x = slot % totalCols
        let y = slot / totalCols
        print("x: \(x), y: \(y)")
        return [x * Int(gridSize), y * Int(gridSize)]
    }

    func createParkingMap() -> [Int] {
        var parkingMap = [Int]()
        let totalRows = Int(backgroundHeight / gridSize)
        let totalCols = Int(backgroundWidth / gridSize)
        for idx in 0..<totalRows * totalCols {
            parkingMap.append(idx)
        }
        return parkingMap.shuffled()
    }
}
struct Planet: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let position: CGPoint
    let size: CGSize
    
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
