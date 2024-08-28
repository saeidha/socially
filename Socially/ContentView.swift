//
//  ContentView.swift
//  Socially
//
//  Created by saeid on 2/18/24.
//

import SwiftUI
import CoreData
import BigInt

@MainActor
struct ContentView: View {
    @State private var ethBalance = ""
    @State private var scrollBalance = ""
    @State private var walletAddress = ""
    @State private var isLoading = false
    

    var web3Helper = Web3Helper()
    var body: some View {
        
        ZStack {
            if isLoading {
                ProgressView()
            } else {
                VStack {
                   
                    if let address = web3Helper.getWalletAddress() {
                        
                        Text("Address:").padding()
                        Text("\(address)")
                            .bold()
                            .background(.orange)
                            .foregroundColor(.white)
                        
                    }
                    if !ethBalance.isEmpty {
                        Spacer(minLength: 5)
                        Text("ETH Balance:").padding()
                            .font(.title3)
                        Text("\(ethBalance)  ETH")
                            .font(.title)
                    }
                    
                    if !scrollBalance.isEmpty {
                        Spacer(minLength: 5)
                        Text("Scroll Balance:").padding()
                            .font(.title3)
                        Text("\(scrollBalance)  ETH")
                            .font(.title)
                    }
                    
                    Spacer()
                    Button("Fetch Balance") {
                        
                        Task {
                            isLoading = true // Show indicator
                               // Make your web3swift request with async/await
                            ethBalance = await web3Helper.getETHBalance() ?? ""
                            scrollBalance = await web3Helper.getScrollBalance() ?? ""
                               // After receiving data, hide indicator
                               isLoading = false
                            
                        }
                    }
                    .buttonStyle(MyButtonStyle())
                    
                    
                }.safeAreaPadding()
            }
        }
        
    }
}



struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.primary))
            )
            .foregroundColor(.white)
            .font(.title3)
            .bold()
    }
}





#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
