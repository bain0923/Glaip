//
//  WristBandAPI.swift
//  
//
//  Created by Mauricio Vazquez on 15/8/22.
//

import SwiftUI

public final class Glaip: ObservableObject {
  private let walletConnect: WalletLinkService

  public let title: String
  public let description: String
  public let supportedWallets: [WalletType]

  public var currentWallet: WalletType?

  @Published public var userState: UserState = .unregistered

  public init(title: String, description: String, supportedWallets: [WalletType], icons: [URL] = [], clientURL: URL = URL(string: "https://safe.gnosis.io")!) {
    self.title = title
    self.description = description
    self.supportedWallets = supportedWallets
    self.walletConnect = WalletLinkService(title: title, description: description, icons: icons, clientURL: clientURL)
  }

  public func loginUser(type: WalletType, completion: @escaping (Result<User, Error>) -> Void) {
    walletLogin(wallet: type, completion: { [weak self] result in
      switch result {
      case let .success(user):
        DispatchQueue.main.async {
          self?.userState = .loggedIn(user)
        }
        self?.currentWallet = type
        completion(.success(user))
      case let .failure(error):
        completion(.failure(error))
      }
    })
  }
    
    public func personalSign(wallet: WalletType, message: String, completion: @escaping (Result<String, Error>) -> Void) {
        walletConnect.sign(wallet: wallet, message: message, completion: completion)
    }

  public func logout() {
    walletConnect.disconnect()
  }

  private func walletLogin(wallet: WalletType, completion: @escaping (Result<User, Error>) -> Void) {
      walletConnect.connect(wallet: wallet, completion: { result in

      switch result {
      case let .success(walletDetails):
        completion(.success(
          User(
            wallet: Wallet(
              type: wallet,
              address: walletDetails.address,
              chainId: String(walletDetails.chainId))
          ))
        )
      case let .failure(error):
        completion(.failure(error))
      }
    })
  }
}
