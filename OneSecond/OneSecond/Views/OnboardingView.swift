//
//  OnbordingVIew.swift
//  OneSecond
//
//  Created by Doran on 6/17/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToNext = false
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing:0) {
                ZStack(alignment: .bottom){
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                    Text("one").font(.custom("Hoefler Text Black", size: 150)).foregroundColor(Color(hex: "FF0080"))
                        .padding(.bottom,-42)
                }
                ZStack(alignment: .top){
                    Rectangle()
                        .foregroundColor(Color(hex: "FF0080"))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    Text("second").font(.custom("Hoefler Text Black", size: 100)).foregroundColor(Color(hex: "000000"))
                        .padding(.top,-10)
                }
            }
        }.edgesIgnoringSafeArea(.top)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    NavigationManager.shared.push(to:.selectYear)
                }
            }
    }
}
        

#Preview {
    OnboardingView()
}
