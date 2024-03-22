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
    let buttonTitle: String
    let action: () -> ()
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color(.white)
                .opacity(0.1)
                .onTapGesture {
                    close()
                }
            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()
                
                Text(message)
                    .font(.body)
                
                Button {
                    action()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.red)
                        
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: 600)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .tint(.black)
                    }
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
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
        withAnimation(.spring()) {
            offset = 1000
            isActive = false
            print("This is offset: \(offset)")
        }
    }
}

#Preview {
    CustomDialog(isActive: .constant(true), title: "hello", message: "world", buttonTitle: "Save", action: {})
}
