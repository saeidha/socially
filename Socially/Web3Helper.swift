//
//  Web3.swift
//  Socially
//
//  Created by saeid on 2/18/24.
//

import web3swift
import Web3Core
import Foundation
import BigInt


class Web3Helper {
    
    
    private let providerETH =  Web3HttpProvider(url: URL(string: "https://sepolia.infura.io/v3/\(Environment.infuraAPIKey)")!, network: .Goerli)
    private let providerScroll =  Web3HttpProvider(url: URL(string: "https://sepolia-rpc.scroll.io")!, network: .Custom(networkID: BigUInt(534351)))
    
    
    func getETHBalance() async -> String?{
        await self.getBalance(provider: self.providerETH)
    }
    func getScrollBalance() async -> String?{
        await self.getBalance(provider: self.providerScroll)
    }
    
    
    
    private func getBalance(provider: Web3HttpProvider) async -> String?{
        guard let walletAddress = getWalletAddress() else {return nil}
        guard let address = EthereumAddress(from: walletAddress) else { return nil }
        
        do {
            let web3 = Web3(provider: provider)
            let balance = try await web3.eth.getBalance(for: address, onBlock: .latest)
            return Web3Core.Utilities.formatToPrecision(balance)
        }catch{
            print("error creating keyStore")
        }
        return nil
    }
    
    
    private func getKeyStoreManager(pK: String) -> KeystoreManager?{
        let formattedKey = pK.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let dataKey = Data.fromHex(formattedKey) else {
            return nil
        }
        do {
            let keystore =  try EthereumKeystoreV3(privateKey: dataKey, password: "")
            if let myWeb3KeyStore = keystore {
                let manager = KeystoreManager([myWeb3KeyStore])
                return manager
            } else {
                print("error")
            }
        } catch {
#if DEBUG
            print("error creating keyStore")
            print("Private key error.")
#endif
        }
        return nil
    }
    
    
    func getWalletAddress(privateKey: String  = Environment.privateKey) -> String?{
        if let manager = self.getKeyStoreManager(pK: privateKey) , let address = manager.addresses?.first, let walletAddress = manager.addresses?.first?.address{
#if DEBUG
            print("Address :::>>>>> ", address)
            print("Address :::>>>>> ", manager.addresses ?? "")
#endif
            
            return walletAddress
        }
        return nil
    }
    
    
    
    //    private func getNFTs(provider: Web3HttpProvider) async -> String?{
    
    //        let contractAddress = ""
    //        let ethContractAddress = EthereumAddress(contractAddress, ignoreChecksum: true)!
    //        let enumerableContract = web3.contract(enumerableABI, at: ethContractAddress)!
    //        let readOp = enumerableContract.createReadOperation(TokenOfOwnerByIndexOperation, parameters: [ownerWalletAddress, BigUInt(index)] as [AnyObject])!
    //        readOp.transaction.from = EthereumAddress(ownerWalletAddress)
    //        let response = try await readOp.callContractMethod()
    //
    //        guard let walletAddress = getWalletAddress() else {return nil}
    //        guard let address = EthereumAddress(from: walletAddress) else { return nil }
    //
    //        do {
    //            let web3 = Web3(provider: provider)
    //            let balance = try await web3.eth.(for: address, onBlock: .latest)
    //            return Web3Core.Utilities.formatToPrecision(balance)
    //        }catch{
    //            print("error creating keyStore")
    //        }
    //        return nil
    //    }
    
    // Similar approach, except using ethereum-swift-utils methods:
    //    func parseTransactionData(inputData: Data) {
    //        // Extract function signature (first 4 bytes) and arguments
    //        let functionSignature = inputData.subdata(in: 0..<4)
    //        let argsData = inputData.subdata(in: 4..<inputData.count)
    //
    //        // Decode arguments based on function signature (implement logic based on your specific case)
    //let this = EthereumContract(<#T##abiString: String##String#>)
    //        print("Function Signature:", functionSignature.toHexString())
    //        print("Decoded Arguments:", decodedArgs ?? [])
    //    }
    
    //        private func getTransactions(provider: Web3HttpProvider) async -> String?{
    //            guard let walletAddress = getWalletAddress() else {return nil}
    //            guard let address = EthereumAddress(from: walletAddress) else { return nil }
    //
    //            do {
    //                let web3 = Web3(provider: provider)
    //                let balance = try await web3.eth.tra(for: address, onBlock: .latest)
    //                return Web3Core.Utilities.formatToPrecision(balance)
    //            }catch{
    //                print("error creating keyStore")
    //            }
    //            return nil
    //        }
}
