//
//  ContentView.swift
//  MyLuckyNumber
//
//  Created by Shivam Kumar Pandey on 07/06/26.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var animateImage = false
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.07, blue: 0.20),
                        Color(red: 0.18, green: 0.10, blue: 0.35)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    
                    Spacer()
                    
                    Image("welcome")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                     .scaleEffect(animateImage ? 1.05 : 0.95)
//                        .animation(
//                            //.easeInOut(duration: 2)
//                            .repeatForever(),
//                            value: animateImage
//                        )
                    
                    VStack(spacing: 10) {
                        
                        Text("Welcome!")
                            .font(.system(size: 38))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Text("Find Your Lucky Number")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.85))
                        
                        Text("Discover your fortune using your name and birth date.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.65))
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    Button {
                        navigateToHome = true
                    } label: {
                        
                        HStack(spacing: 10) {
                            
                            Image(systemName: "sparkles")
                            
                            Text("Get Started")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                colors: [
                                    .yellow,
                                    .orange
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(
                            color: .yellow.opacity(0.4),
                            radius: 10
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                        .frame(height: 40)
                }
                .navigationDestination(isPresented: $navigateToHome) {
                    HomeView()
                }
            }
            
            .onAppear {
                animateImage = true
            }
        }
    }
}

//#Preview {
//    WelcomeView()
//}
