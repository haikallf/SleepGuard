//
//  HomeView.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 18/05/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {            
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.gray.opacity(0.09), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 220)
                
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color("yellow"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 220)
                    .rotationEffect(.init(degrees: -90))
                
                
                VStack{
                    
                    Text("7hr 16m")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("remaining")
                        .font(.callout)
                }
            }
            .padding(.vertical, 48)
            
            HStack {
                Image(systemName: "bed.double.fill")
                    .padding(.trailing, -4)
                
                Text("Sleep | Wake Up")
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .font(.title3)
            
            Divider()
                .padding(.top, -10)
            
            HStack {
                VStack (alignment: .leading) {
                    Text("08.00")
                        .font(.system(size: 45))
                    
                    Text("This Morning")
                        .font(.subheadline)
                }
                .fontWeight(.light)
                
                Spacer()
                
                Button(action: {}, label: {
                    Text("CHANGE")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .font(.subheadline)
                        .foregroundColor(Color("yellow"))
                        .background(Color("darkGray"))
                        .fontWeight(.semibold)
                        
                })
                .clipShape(Capsule())
            }
            .padding(.top, -16)
            
            Divider()
            
            Spacer()
        }
        .padding()
        .navigationTitle("SleepGuard")
    }  
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
