//
//  CustomDialog.swift
//  demo
//
//  Created by Nguyen Viet Khoa on 22/03/2024.
//

import SwiftUI

struct CustomDialog: View {
    
    @Binding var isActive: Bool
    
    let title: String
    let message: String
    let image: String
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color(.white)
                .opacity(0.1)
                .onTapGesture {
                    close()
                }
            VStack {
                ScrollView {
                    VStack {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                        Text(title)
                            .font(.title2)
                            .bold()
                            .padding()
                        Text(message)
                            .font(.body)
                    }
                }
                .padding(.bottom, 50)
            }
            .fixedSize(horizontal: false, vertical: false)
            .frame(width: 350, height: 650, alignment: .top)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            close()
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color.black.opacity(0.7))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    HStack (alignment: .center) {
                        Circle()
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            // Nickname
                            Text("Nickname")
                                .font(.subheadline)
                                .foregroundColor(.primary)

                            
                            // ID
                            Text("@id")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("20/03/2012")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding()
                    }
                    .frame(height: 50)
                    .background(Color.white)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .shadow(radius: 20)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
        }
        
    func close() {
        offset = 1000
        isActive = false
    }
}

#Preview {
    CustomDialog(isActive: .constant(true), title: "This is the title", message: "Hello, everyone! This is the LONGEST TEXT EVER! I was inspired by the various other on the internet, and I wanted to make my own. So here it is! This is going to be a WORLD RECORD! This is actually my third attempt at doing this. The first time, I didn't save it. The second time, the Neocities editor crashed. Now I'm writing this in Notepad, then copying it into the Neocities editor instead of typing it directly in the Neocities editor to avoid crashing. It sucks that my past two attempts are gone now. Those actually got pretty long. Not the longest, but still pretty long. I hope this one won't get lost somehow. Anyways, let's talk about WAFFLES! I like waffles. Waffles are cool. Waffles is a funny word. There's a Teen Titans Go episode ", image: "thumbnail")
}
