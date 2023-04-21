//
//  WalletLinkService.swift
//  
//
//  Created by Mauricio Vazquez on 15/8/22.
//

import Foundation

import WalletConnectSwift
import SwiftUI

public protocol WalletService {
  func connect(wallet: WalletType, completion: @escaping (Result<WalletDetails, Error>) -> Void)
  func sign(wallet: WalletType, message: String, completion: @escaping (Result<String, Error>) -> Void)
}

public struct WalletDetails {
  public let address: String
  public let chainId: Int

  public init(address: String, chainId: Int) {
    self.address = address
    self.chainId = chainId
  }
}

public final class WalletLinkService: WalletService {
  private let title: String
  private let description: String
  private let icons: [URL]
  private let clientURL: URL

  private var walletConnect: WalletConnect!
  private var onDidConnect: ((WalletDetails) -> Void)?

  public init(title: String, description: String, icons: [URL], clientURL: URL) {
    self.title = title
    self.description = description
    self.icons = icons
    self.clientURL = clientURL

    setWalletConnect()
  }

  public func connect(wallet: WalletType, completion: @escaping (Result<WalletDetails, Error>) -> Void) {
    openAppToConnect(wallet: wallet, getDeepLink(wallet: wallet), delay: 1)

    // Temp fix to avoid threading issue with async await
    let lock = NSLock()

    onDidConnect = { walletInfo in
      lock.lock()
      defer { lock.unlock() }

      completion(.success(walletInfo))
    }
  }

  public func disconnect() {
    do {
      guard let session = walletConnect.session else { return }

      try walletConnect.client.disconnect(from: session)
    } catch {
      print("error disconnecting")
    }
  }

  public func sign(wallet: WalletType, message: String, completion: @escaping (Result<String, Error>) -> Void) {
    openAppToConnect(wallet: wallet, getDeepLink(wallet: wallet), delay: 1)

    walletConnect.sign(message: message, completion: completion)
  }
    
    public func sendTransaction(wallet: WalletType, transaction: Client.Transaction, completion: @escaping (Result<String, Error>) -> Void) {
      openAppToConnect(wallet: wallet, getDeepLink(wallet: wallet), delay: 1)

      walletConnect.sendTransaction(transaction: transaction, completion: completion)
    }

  private func setWalletConnect() {
    walletConnect = WalletConnect(delegate: self)
    walletConnect.reconnectIfNeeded()
  }

  private func openAppToConnect(wallet: WalletType, _ url: String, delay: CGFloat = 0) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      if let url = URL(string: self.getDeepLink(wallet: wallet)), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
  }

  private func getDeepLink(wallet: WalletType) -> String {
    let connectionUrl: String
    if let wcUrl = walletConnect.wurl {
      connectionUrl = wcUrl.absoluteString
    } else {
      connectionUrl = walletConnect.connect(title: title, description: description, icons: icons, clientURL: clientURL)
    }
     
    let encodeURL = connectionUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let end = encodeURL.replacingOccurrences(of: "=", with: "%3D").replacingOccurrences(of: "&", with: "%26")

    return "\(wallet.rawValue)\(end)"
  }
}

// MARK: - WalletConnectDelegate
extension WalletLinkService: WalletConnectDelegate {
  func didUpdate() {
  }

  func failedToConnect() {
  }

  func didConnect() {
    guard
      let session = walletConnect.session,
      let walletInfo = session.walletInfo,
      let walletAddress = walletInfo.accounts.first
    else { return }

    onDidConnect?(WalletDetails(address: walletAddress, chainId: walletInfo.chainId))
  }

  func didDisconnect() {
  }
}

