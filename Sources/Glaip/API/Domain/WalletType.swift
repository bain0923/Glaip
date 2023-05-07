//
//  WalletType.swift
//  
//
//  Created by Mauricio Vazquez on 15/8/22.
//

public enum WalletType: String, Equatable, CaseIterable, Codable {
    case Rainbow = "https://rnbwapp.com/wc?uri="
    case TrustWallet = "https://link.trustwallet.com/wc?uri="
    case MetaMask = "https://metamask.app.link/wc?uri="
    case Safe = "https://app.safe.global/wc?uri="
    case Uniswap = "https://uniswap.org/app/wc?uri="
    case Ledger = "ledgerlive://wc?uri="
    case Zerion = "https://wallet.zerion.io/wc?uri="
    case Omni = "https://links.omni.app/wc?uri="
}

extension WalletType {
    
    public var native: String {
        switch self {
        case .Rainbow:
            return "rainbow://"
        case .TrustWallet:
            return "trust://"
        case .MetaMask:
            return "metamask://"
        case .Safe:
            return ""
        case .Uniswap:
            return ""
        case .Ledger:
            return "ledgerlive://"
        case .Zerion:
            return "zerion://"
        case .Omni:
            return "omni://"
        }
    }
    
    public var shortName: String {
        switch self {
        case .Rainbow:
            return "Rainbow"
        case .TrustWallet:
            return "Trust"
        case .MetaMask:
            return "MetaMask"
        case .Safe:
            return "Safe"
        case .Uniswap:
            return "Uniswap"
        case .Ledger:
            return "Ledger"
        case .Zerion:
            return "Zerion"
        case .Omni:
            return "Omni"
        }
    }
    
    public var imageURL: String {
        switch self {
        case .Rainbow:
            return "https://explorer-api.walletconnect.com/v3/logo/sm/7a33d7f1-3d12-4b5c-f3ee-5cd83cb1b500?projectId=eda51b55f58f803b3ee1d9aca71e3a94"
        case .TrustWallet:
            return "https://explorer-api.walletconnect.com/v3/logo/md/0528ee7e-16d1-4089-21e3-bbfb41933100?projectId=eda51b55f58f803b3ee1d9aca71e3a94"
        case .MetaMask:
            return "https://explorer-api.walletconnect.com/v3/logo/md/5195e9db-94d8-4579-6f11-ef553be95100?projectId=eda51b55f58f803b3ee1d9aca71e3a94"
        case .Safe:
            return "https://explorer-api.walletconnect.com/v3/logo/md/a1cb2777-f8f9-49b0-53fd-443d20ee0b00?projectId=eda51b55f58f803b3ee1d9aca71e3a94"
        case .Uniswap:
            return "https://explorer-api.walletconnect.com/v3/logo/md/bff9cf1f-df19-42ce-f62a-87f04df13c00?projectId=eda51b55f58f803b3ee1d9aca71e3a94"
        case .Ledger:
            return "https://explorer-api.walletconnect.com/v3/logo/md/a7f416de-aa03-4c5e-3280-ab49269aef00?projectId=eda51b55f58f803b3ee1d9aca71e3a94"
        case .Zerion:
            return "https://explorer-api.walletconnect.com/v3/logo/md/f216b371-96cf-409a-9d88-296392b85800?projectId=eda51b55f58f803b3ee1d9aca71e3a94"
        case .Omni:
            return "https://explorer-api.walletconnect.com/v3/logo/md/2cd67b4c-282b-4809-e7c0-a88cd5116f00?projectId=eda51b55f58f803b3ee1d9aca71e3a94"
        }
    }
}
